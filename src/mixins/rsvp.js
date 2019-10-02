import { removeEventParticipant, initProxySession, submitEventParticipant } from '@/utils/api'
import { submitToSheetsu } from '@/utils/vendor'
import { trackEvent } from '@/utils/ahoy'
import { alerts } from '@/mixins'
import moment from 'moment'

export default {
  mixins: [alerts],
  computed: {
    formattedDateTime () {
      return this.event.startsAt.format('MMM D') + ' at ' + this.event.startsAt.format('ha')
    },
    participantFirstName () {
      return this.currentUser.firstName
    },
    messageToHost () {
      return `Hi ${this.event.user.firstName}, ${this.participantFirstName} ` +
        `just booked a playdate with you on ` +
        this.formattedDateTime +
        `. Reply to this message to say hi! ` +
        `Or cancel here: ${window.location.origin}/event/${this.event.id}`
    },
    messageToParticipant () {
      return `Hi ${this.participantFirstName}, meet ${this.event.user.firstName}! ` +
        `We've sent them your request for a playdate ` +
        this.formattedDateTime +
        `. Reply to this message to introduce yourself or ask a question!`
    }
  },
  methods: {
    initiateDeclineRsvp () {
      if (!this.redirectToSignupIfNotAuthenticated({
        name: 'DeclineRSVP',
        params: { eventId: this.event.id }
      })) {
        this.$router.push({ name: 'DeclineRSVP', params: { eventId: this.event.id } })
      }
    },
    submitToSheetsu: function () {
      const data = {
        'Event ID': this.eventId,
        'Event title': this.event.name,
        'Event host': this.event.user.firstName,
        'Event date': this.event.startsAt,
        'Date submitted': moment(Date()).format('L'),
        'Parent first name': this.currentUser.firstName,
        'Parent last name': this.currentUser.lastInitial,
        'Parent phone': this.currentUser.phone,
        'Parent email': this.currentUser.email,
        'IDs of RSVPed children': this.childrenSelected,
        'All children': this.currentUser.children
      }
      submitToSheetsu(data, 'RSVPs')
    },
    async cancelRsvp () {
      try {
        const res = await removeEventParticipant(this.eventId)
        trackEvent('rsvp_cancel', { eventId: this.eventId })
        this.$ga.event('RSVP', 'canceled', this.eventId)
        const data = {
          'User ID': this.currentUser.id,
          'Cancelation Time': moment(Date()).format('LLLL'),
          'Event ID': this.eventId,
          'Reason for cancelation': this.reason,
          'Event title': this.event.name,
          'Event host': this.event.user.firstName,
          'Event date': this.event.startsAt.toString(),
          'Parent first name': this.currentUser.firstName,
          'Parent last name': this.currentUser.lastInitial,
          'Parent phone': this.currentUser.phone,
          'Parent email': this.currentUser.email,
          'All children': this.currentUser.children
        }
        submitToSheetsu(data, 'RSVPCancelations')
        return res
      } catch (err) {
        console.log(err)
        throw err
      }
    },
    async submitRsvp (childIds) {
      this.err = ''
      const eventId = this.event.id || this.$route.params.eventId
      this.submitToSheetsu()

      try {
        const res = await submitEventParticipant(eventId, childIds)
        trackEvent('rsvp_affirmative', { eventId: eventId })
        this.showAlertOnNextRoute(`Playdate request sent for ${this.formattedDateTime}. ` +
            'We\'re texting you now, to introduce you to ' +
            `${this.event.user.firstName}!`, 'success'
        )
        this.$ga.event('RSVP', 'sent', eventId)
        this.initProxyConversation()
        this.$router.push({ name: 'EventPage', params: { id: eventId } })
        return res
      } catch (err) {
        console.log(err)
        this.err = 'Sorry, there was a problem submitting your RSVP. Try again?'
      }
    },
    initProxyConversation () {
      initProxySession(
        this.currentUser.id,
        this.event.user.id,
        this.messageToHost,
        this.messageToParticipant
      )
    }
  }
}
