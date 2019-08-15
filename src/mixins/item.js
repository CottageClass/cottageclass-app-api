import { andJoin, distanceHaversine } from '@/utils/utils'
import { starUser, unstarUser, darkStarUser, undarkStarUser } from '@/utils/api/stars'
import { mapGetters } from 'vuex'
import moment from 'moment'
import languageList from 'language-list'

import { redirect } from '@/mixins'
import rsvp from '@/mixins/rsvp'
import waves from '@/mixins/waves'
import { deleteEvent, fetchUpcomingEvents } from '@/utils/api'

export default {
  mixins: [ redirect, rsvp, waves ],
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
      if (this.user) {
        return this.user.images
      }
      return this.event && this.event.hostImages
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
        return 'Speaks ' + languages[0]
      }
      return 'Speaks ' + andJoin(languages)
    },
    verified () {
      return !!this.user.facebookUid
    },
    isCurrentUser () {
      return this.user.id.toString() === this.currentUser.id.toString()
    },
    showGoingButton () {
      return this.event &&
        !this.timePast &&
        (!this.currentUser ||
        (this.event.host.id.toString() !== this.currentUser.id.toString()))
    },
    showInterestedButton () {
      return !this.childcareRequest && // don't show for childcare requests
        this.isAuthenticated &&
        this.currentUser &&
        (this.user.id.toString() !== this.currentUser.id.toString())
    },
    showContactButton () {
      return !!this.childcareRequest // only show for childcare requests
    },
    showCancelButton () {
      return this.event &&
        !this.timePast &&
        (this.event.host.id.toString() === this.currentUser.id.toString())
    },
    showMeetButton () {
      return !this.childcareRequest && // don't show for childcare requests
       (!this.currentUser || (this.user.id.toString() !== this.currentUser.id.toString()))
    },
    showShareButton () {
      return this.event && this.$route.name !== 'SocialInvite'
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
    distance () {
      const center = this.mapCenter || (this.currentUser && this.currentUser.location)
      if (!center) { return null }
      if (this.event) {
        return distanceHaversine(
          this.event.hostFuzzyLatitude,
          this.event.hostFuzzyLongitude,
          center.lat,
          center.lng) + ' mi'
      }
      if (this.user) {
        return distanceHaversine(
          this.user.fuzzyLatitude,
          this.user.fuzzyLongitude,
          center.lat,
          center.lng) + ' mi'
      }
      return null
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
        return moment(this.event.startsAt).format('ddd, MMMM D ha') + '-' + moment(this.event.endsAt).format('ha')
      }
      if (this.childcareRequest) {
        return 'CHILDCARE REQUESTED'
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
      return 'Ages ' + andJoin(ages.map((e, i) => this.ageString(i)))
    },
    userFirstName () {
      return (this.event && this.event.hostFirstName) || (this.user && this.user.firstName)
    },
    userLastInitial () {
      return (this.event && this.event.host.lastInitial) ||
        (this.user && this.user.lastInitial) ||
        ''
    },
    userName () {
      return this.userFirstName + ' ' + this.userLastInitial + '.'
    },
    description () {
      if (this.event) {
        return this.event.name
      }
      if (this.childcareRequest) {
        return this.childcareRequest.content
      }
      return this.user.profileBlurb
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
    occupation () {
      const position = this.user.jobPosition
      const employer = this.user.employer
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
      deleteEvent(this.event.id, () => {
        this.$emit('event-deleted', this.event.id)
        this.showBriefAllert('Your event has been deleted', 'success')
      })
    },
    shareClick () {
      this.$router.push({ name: 'SocialInvite', params: { id: this.event.id, context: 'searchItem' } })
    },
    goingClick () {
      if (this.redirectToSignupIfNotAuthenticated({
        name: 'RsvpInfoCollection',
        params: { eventId: this.event.id }
      })) {
      } else if (this.event.participated) {
        this.$router.push({ name: 'CancelRSVP', params: { eventId: this.event.id } })
      } else {
        if (this.currentUser.children.length === 1) {
          this.submitRsvp(this.currentUser.children.map(c => c.id))
        } else {
          this.$router.push({ name: 'RsvpInfoCollection', params: { eventId: this.event.id } })
        }
      }
    },
    async disinterestedClick () {
      let res
      if (this.user.darkStarred) {
        res = await undarkStarUser(this.user.id)
      } else {
        res = await darkStarUser(this.user.id)
      }
      this.$emit('user-updated', res)
      return res
    },
    async interestedClickWithPrompts (likedUser, events) {
      let res
      if (this.user.starred) {
        res = await unstarUser(this.user.id)
      } else {
        if (!events) {
          events = await fetchUpcomingEvents(likedUser.id)
        }
        if (events.length > 0) {
          this.$router.push({ name: 'SelectEventFromUser', params: { userId: likedUser.id } })
        } else {
          this.checkAuthenticationAndInitiateMessageSending()
        }
        res = await starUser(this.user.id)
      }
      this.updateUser(res)
      return res
    },
    async interestedClick () {
      let res
      if (this.user.starred) {
        res = await unstarUser(this.user.id)
      } else {
        res = await starUser(this.user.id)
      }
      this.$emit('user-updated', res)
      return res
    },
    goToItem () {
      if (this.event) {
        this.$router.push({ name: 'EventPage', params: { id: this.event.id } })
      } else if (this.childcareRequest) {
        this.$router.push({ name: 'ChildcareRequestPage', params: { id: this.childcareRequest.id } })
      } else if (this.user) {
        this.$router.push({ name: 'UserPage', params: { id: this.user.id } })
      } else {
        throw Error('No valid item on this list card')
      }
    }
  }
}
