import { initProxySession } from '@/utils/api'
import { alerts, messaging } from '@/mixins'

export default {
  mixins: [alerts, messaging],
  methods: {
    checkAuthenticationAndInitiateMessageSending () {
      if (this.redirectToSignupIfNotAuthenticated()) {
        this.$store.commit('addPendingWave', { targetUser: this.targetUser })
      } else {
        if (this.allowUndo) {
          this.initiateMessageSending()
        } else {
          this.sendMessage()
        }
      }
    },
    sendMessage: async function () {
      try {
        this.debug(this.targetUser)
        await initProxySession(this.currentUser.id,
          this.targetUser.id,
          this.meetMessage(this.targetUser),
          this.acknowledgeMessage(this.targetUser))
        this.meetStatus = 'sent'
        this.$store.commit('addSentWave', { targetUserId: this.targetUser.id })
      } catch (e) {
        console.error(e)
        this.meetStatus = 'none'
        this.showBriefAllert('There was a problem sending your message.  Please try again later', 'failure')
      }
    }
  }
}
