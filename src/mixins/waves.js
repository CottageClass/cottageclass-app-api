import { mapGetters, mapMutations } from 'vuex'

import { alerts, messaging } from '@/mixins'
import { initProxySession } from '@/utils/api'

export default {
  mixins: [ alerts, messaging ],
  data () {
    return {
      currentUserEvents: null
    }
  },
  computed: {
    async currentUserHasEvents () {
      return this.currentUser && this.currentUser.upcomingEventsCount > 0
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    checkAuthenticationAndInitiateMessageSending () {
      if (this.redirectToSignupIfNotAuthenticated()) {
        this.addPendingWave({ targetUser: this.targetUser })
      } else {
        if (this.allowUndo) {
          this.initiateMessageSending()
        } else {
          this.sendMessage()
          this.showAlertOnNextRoute('Your message has been sent', 'success')
        }
      }
    },
    async handleWave () {
      if (this.currentUser && this.currentUserHasEvents) {
        try {
          await this.sendMessage()
          this.showAlertOnNextRoute('Your message has been sent', 'success')
        } catch (e) {
          this.logError(e)
          this.showAlertOnNextRoute('Something went wrong.  Please try again later', 'failure')
        }
        this.$router.push({ name: 'UserPage', params: { id: this.targetUser.id } })
      } else {
        this.addPendingWave({ targetUser: this.targetUser })
        this.$router.push({ name: 'AddOffersPrompt', params: { userId: this.targetUser.id } })
      }
    },
    sendMessage: async function () {
      try {
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
    },
    ...mapMutations(['addPendingWave'])
  }
}
