import { initProxySession, submitEventParticipant } from '@/utils/api'
import { submitToSheetsu } from '@/utils/vendor'
import moment from 'moment'

export default {
  computed: {
    formattedDateTime () {
      return this.event.startsAt.format('MMM D') + ' at ' + this.event.startsAt.format('ha')
    },
    participantFirstName () {
      return this.currentUser.firstName
    },
    hostFirstName () {
      return this.event.host.firstName
    },
    messageToHost () {
      return `Hi ${this.hostFirstName}, ${this.participantFirstName} ` +
        `just booked a playdate with you on ` +
        this.formattedDateTime +
        `. Reply to this message to say hi! ` +
        `Or cancel here: https://kidsclub.io/events/${this.event.id}`
    },
    messageToParticipant () {
      return `Hi ${this.participantFirstName}, meet ${this.hostFirstName}! ` +
        `We've sent them your request for a playdate ` +
        this.formattedDateTime +
        `. Reply to this message to introduce yourself or ask a question!`
    }
  },
  methods: {
    submitToSheetsu: function () {
      const data = {
        'Event ID': this.eventId,
        'Event title': this.event.name,
        'Event host': this.event.hostFirstName,
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
    async submitRsvp (childIds) {
      this.err = ''
      console.log('rsvping children ' + childIds + ' to event ID' + this.event.id)
      this.submitToSheetsu()

      try {
        await submitEventParticipant(this.event.id, childIds)
        this.$store.commit('showAlertOnNextRoute', {
          alert: {
            message: `Playdate request sent for ${this.formattedDateTime}. ` +
            'We\'re texting you now, to introduce you to ' +
            `${this.hostFirstName}!`,
            status: 'success'
          }
        })
        this.$ga.event('RSVP', 'sent', this.event.id)
        this.initProxyConversation()
        this.$router.push({ name: 'EventPage', params: { id: this.event.id } })
      } catch (err) {
        console.log(err)
        this.err = 'Sorry, there was a problem submitting your RSVP. Try again?'
      }
    },
    initProxyConversation () {
      initProxySession(
        this.currentUser.id,
        this.event.hostId,
        this.messageToHost,
        this.messageToParticipant
      )
    }
  }
}
