import { andJoin, distanceHaversine, capitalize } from '@/utils/utils'
import { mapGetters } from 'vuex'
import moment from 'moment'
import languageList from 'language-list'

import { redirect } from '@/mixins'
import rsvp from '@/mixins/rsvp'
import stars from '@/mixins/stars'
import waves from '@/mixins/waves'
import { fetchEvent, fetchUpcomingEvents } from '@/utils/api'

export default {
  mixins: [ redirect, rsvp, waves, stars ],
  data () {
    return {
      overlayOpen: false
    }
  },
  computed: {
    neighborhood () {
      return this.user && this.user.neighborhood
    },
    images () {
      if (this.event && this.event.images) {
        return [...this.event.images, ...this.user.images]
      }
      if (this.user) {
        return this.user.images
      }
    },
    joinedDateFormatted: function () {
      return moment(this.user.createdAt).format('MMMM, YYYY')
    },
    interests () {
      if (this.user && this.user.activities) {
        return this.user.activities.length && this.user.activities
      }
      return null
    },
    languageText: function () {
      const languageCodes = this.user.languages
      const languages = languageCodes.map(languageList().getLanguageName)
      if (languages.length === 0) {
        return ''
      }
      if (languages.length === 1) {
        if (languages[0] === 'English') {
          return ''
        } else {
          return 'Speaks ' + languages[0]
        }
      }
      return 'Speaks ' + andJoin(languages)
    },
    verified () {
      return !!this.user.facebookUid
    },
    isCurrentUser () {
      return this.user && this.currentUser && this.user.id.toString() === this.currentUser.id.toString()
    },
    showGoingButton () {
      return this.event &&
        !this.timePast &&
        (!this.currentUser ||
        (this.event.user.id.toString() !== this.currentUser.id.toString()))
    },
    showInterestedButton () {
      return this.isAuthenticated &&
        this.currentUser &&
        (this.user.id.toString() !== this.currentUser.id.toString())
    },
    showCancelButton () {
      return this.event &&
        !this.timePast &&
        (this.event.user.id.toString() === this.currentUser.id.toString())
    },
    showMeetButton () {
      return (!this.currentUser || (this.user.id.toString() !== this.currentUser.id.toString()))
    },
    showShareButton () {
      return this.event && this.$route.name !== 'SocialEventInvite'
    },
    attendees () {
      if (!this.event) { return [] }
    },
    isDarkStarred () {
      return this.user.darkStarred
    },
    isStarred () {
      return this.user.starred
    },
    place () {
      if (this.event) { return this.event.place }
      return this.user.place
    },
    distance () {
      const currentUserCenter = this.currentUser &&
        {
          lat: this.currentUser.place.latitude,
          lng: this.currentUser.place.longitude
        }
      const center = this.distanceCenter || currentUserCenter
      if (!center) { return null }
      return distanceHaversine(
        this.place.latitude || this.place.fuzzyLatitude,
        this.place.longitude || this.place.fuzzyLongitude,
        center.lat,
        center.lng) + ' mi'
    },
    availableTimes () {
      if (this.user) {
        const res = []
        if (this.user.availableMornings) {
          res.push('Weekday mornings')
        }
        if (this.user.availableAfternoons) {
          res.push('Weekday afternoons')
        }
        if (this.user.availableEvenings) {
          res.push('Weekday evenings')
        }
        if (this.user.availableWeekends) {
          res.push('Weekends')
        }
        return res.length && res
      }
      return null
    },
    timeHeader () {
      if (this.event) {
        return moment(this.event.startsAt).format('ddd, MMMM D h:mma') + '-' + moment(this.event.endsAt).format('h:mma')
      }
      const availabilityStrings = []
      if (this.user.availableMornings) {
        availabilityStrings.push('mornings')
      }
      if (this.user.availableAfternoons) {
        availabilityStrings.push('afternoons')
      }
      if (this.user.availableEvenings) {
        availabilityStrings.push('evenings')
      }
      if (this.user.availableWeekends) {
        availabilityStrings.push('weekends')
      }
      if (availabilityStrings.length > 0) {
        return 'Available ' + andJoin(availabilityStrings)
      }
      return 'contact for availability'
    },

    eventTimeHeader () {
      if (this.event) {
        return moment(this.event.startsAt).format('ddd, MMM D') + ' at ' + moment(this.event.startsAt).format('h:mm a')
      }
    },

    ageString () {
      return (i) => {
        const ageInMonths = this.user.childAgesInMonths[i]
        if (ageInMonths < 24) {
          return ageInMonths + (ageInMonths === 1 ? ' mo' : ' mos')
        }
        return Math.floor(ageInMonths / 12).toString()
      }
    },
    kidsAges () {
      const ages = this.user.childAgesInMonths
      if (!ages || ages.length === 0) {
        return ''
      }
      if (ages.length === 1) {
        return '1 child age ' + this.ageString(0)
      }
      return 'Children ages ' + andJoin(ages.map((e, i) => this.ageString(i)))
    },
    userFirstName () {
      return this.user && this.user.firstName
    },
    userLastInitial () {
      return (this.event && this.event.user.lastInitial) ||
        (this.user && this.user.lastInitial) || (this.user && this.user.lastName && this.user.lastName[0])
    },
    userName () {
      return this.userFirstName + ' ' + this.userLastInitial + '.'
    },
    mainTitle () {
      if (this.event) {
        if (this.event.description) {
          const regex = /\.*$/
          const trimmedName = this.event.name && this.event.name.trim().replace(regex, '')
          return trimmedName + '. ' + (this.event.description || '')
        } else {
          return this.event.name
        }
      }
      return this.user.profileBlurb
    },
    name () {
      if (this.event) {
        return this.event.name
      }
    },
    description () {
      if (this.event.description) {
        return this.event.description
      }
    },
    playdateLocationName () {
      if (this.place.public) {
        return this.event.place.name
      } else {
        return `The playdate will be hosted at ${this.event.user.firstName}'s home. `
      }
    },
    playdateLocationNameListItem () {
      if (this.playdateLocationName && this.place.public) {
        return `${this.event.place.name}. `
      } else {
        return ''
      }
    },
    profileBlurb () {
      return this.user.profileBlurb
    },
    houseRules () {
      return this.user.houseRules || (this.event && this.event.houseRules)
    },
    petDescription () {
      return this.user.petDescription || (this.event && this.event.petDescription)
    },
    localArea () {
      const neighborhood = this.place.neighborhood
      const cityOrBoro = this.place.locality || this.place.vicinity
      const state = this.place.adminAreaLevel1
      return [neighborhood, cityOrBoro, state].filter(e => !!e).join(', ')
    },
    occupation () {
      const position = capitalize(this.user.jobPosition)
      const employer = capitalize(this.user.employer)
      if (position && employer) {
        return position + ', ' + employer
      } else if (position) {
        return position
      } else if (employer) {
        return employer
      } else {
        return null
      }
    },
    timePast () {
      if (this.event) {
        return moment(this.event.startsAt) < moment().subtract(1, 'hours')
      }
      return false
    },
    showOverlay () {
      return this.isPhone && this.overlayOpen
    },
    ...mapGetters([ 'currentUser', 'isAuthenticated' ])
  },
  methods: {
    contactClick () {
      this.$router.push({ name: 'ContactUserForm', params: { userId: this.user.id } })
    },
    cancelClick () {
      this.$router.push({ name: 'EventPage', params: { id: this.event.id, showDeleteConfirmationModal: true } })
    },
    shareClick () {
      this.$router.push({ name: 'SocialEventInvite', params: { id: this.event.id, context: 'searchItem' } })
    },
    async goingClick () {
      if (this.redirectToSignupIfNotAuthenticated({
        name: 'RsvpInfoCollection',
        params: { eventId: this.event.id }
      })) {
      } else if (this.event.participated) {
        this.$router.push({ name: 'CancelRSVP', params: { eventId: this.event.id } })
      } else {
        if (this.currentUser.children.length === 1) {
          await this.submitRsvp(this.currentUser.children.map(c => c.id))
          this.event = await fetchEvent(this.event.id)
        } else {
          this.$router.push({ name: 'RsvpInfoCollection', params: { eventId: this.event.id } })
        }
      }
    },
    async interestedClickWithPrompts (context) {
      let res
      if (!this.redirectToSignupIfNotAuthenticated({
        name: 'SelectEventFromUser',
        params: { userId: this.user.id },
        query: { interested: 'yes' }
      })) {
        if (this.user.starred) {
          res = await this.unstarUser(this.user.id, context)
        } else {
          res = await this.starUser(this.user.id, context)
          const events = await fetchUpcomingEvents(this.user.id)
          if (events.length > 0) {
            if (events.filter(e => !e.participated).length > 0) {
              this.$router.push({ name: 'SelectEventFromUser', params: { userId: this.user.id } })
            }
          } else {
            this.checkAuthenticationAndInitiateMessageSending()
          }
          res = await this.starUser(this.user.id)
        }
        this.updateUser(res)
      }
      return res
    },
    async interestedClick (context) {
      let res
      if (this.user.starred) {
        res = await this.unstarUser(this.user.id, context)
      } else {
        res = await this.starUser(this.user.id, context)
      }
      this.$emit('user-updated', { user: res })
      return res
    },
    goToItem () {
      if (this.event) {
        this.$router.push({ name: 'EventPage', params: { id: this.event.id } })
      } else if (this.user) {
        this.$router.push({ name: 'UserPage', params: { id: this.user.id } })
      } else {
        throw Error('No valid item on this list card')
      }
    }
  }
}
