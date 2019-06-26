import { andJoin, distanceHaversine } from '@/utils/utils'
import { starEvent, unstarEvent, starUser, unstarUser } from '@/utils/api/stars'
import { mapGetters } from 'vuex'
import moment from 'moment'
import languageList from 'language-list'

export default {
  mixins: [screen],
  data () {
    return {
      overlayOpen: false
    }
  },
  computed: {
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
    showGoingButton () {
      return this.event &&
        !this.timePast &&
        (!this.currentUser ||
        (this.event.host.id.toString() !== this.currentUser.id.toString()))
    },
    showInterestedButton () {
      return this.isAuthenticated && this.currentUser && (this.user.id.toString() !== this.currentUser.id.toString())
    },
    showContactButton () {
      return !this.currentUser || (this.user.id.toString() !== this.currentUser.id.toString())
    },
    showShareButton () {
      return this.event && this.$route.name !== 'SocialInvite'
    },
    attendees () {
      if (!this.event) { return [] }
    },
    isStarred () {
      if (this.event) { return this.event.starred }
      if (this.user) { return this.user.starred }
      throw Error('no item present')
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
          res.push('9am-3pm')
        }
        if (this.user.availableAfternoons) {
          res.push('3pm-7pm')
        }
        if (this.user.availableEvenings) {
          res.push('7pm- ?')
        }
        if (this.user.availableWeekends) {
          res.push('weekends')
        }
        return res.length && res
      }
      return null
    },
    timeHeader () {
      if (this.event) {
        return moment(this.event.startsAt).format('ddd, MMMM D ha') + '-' + moment(this.event.endsAt).format('ha')
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
        return moment(this.event.endsAt) < moment().add(2, 'hours')
      }
      return false
    },
    showOverlay () {
      return this.isPhone && this.overlayOpen
    },
    ...mapGetters([ 'currentUser', 'isAuthenticated' ])
  },
  methods: {
    async interestedClick () {
      let res
      if (this.event) {
        if (this.event.starred) {
          res = await unstarEvent(this.event.id)
        } else {
          res = await starEvent(this.event.id)
        }
        this.$emit('event-updated', res)
      } else if (this.user) {
        if (this.user.starred) {
          res = await unstarUser(this.user.id)
        } else {
          res = await starUser(this.user.id)
        }
        this.$emit('user-updated', res)
      }
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
