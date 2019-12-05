import { removeEventParticipant, submitEventParticipant } from '@/utils/api'
import { trackEvent } from '@/utils/ahoy'
import { alerts } from '@/mixins'

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
    async cancelRsvp () {
      try {
        const res = await removeEventParticipant(this.event.id)
        trackEvent('rsvp_cancel', { eventId: this.event.id })
        this.$ga.event('RSVP', 'canceled', this.event.id)
        this.showAlert('You are no longer attending.  Your presence will be missed.', 'failure')
        return res
      } catch (err) {
        console.log(err)
        throw err
      }
    },
    async submitRsvp (childIds, goToEventPage = true) {
      this.err = ''
      const eventId = this.event.id || this.$route.params.eventId
      try {
        const res = await submitEventParticipant(eventId, childIds)
        trackEvent('rsvp_affirmative', { eventId: eventId })
        this.showAlert(`Attending "${this.event.name}" on ${this.event.startsAt.format('MMM D [at] ha')}`, 'success')
        this.$ga.event('RSVP', 'sent', eventId)
        if (goToEventPage) {
          this.$router.push({ name: 'EventPage', params: { id: eventId } })
        }
        return res
      } catch (err) {
        console.log(err)
        this.err = 'Sorry, there was a problem submitting your RSVP. Try again?'
      }
    }
  }
}
