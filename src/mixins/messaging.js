import { initProxySession } from '@/utils/api'
import { childAgeSentenceText } from '@/utils/utils'
import { mapGetters } from 'vuex'

export default {
  computed: {
    messageChildAgeString () {
      const childAgesInMonths = this.currentUser.childAgesInMonths
      return childAgeSentenceText({ childAgesInMonths })
    },
    meetMessage () {
      return (targetUser) => {
        if (!targetUser) { return '' }
        return `${this.currentUser.firstName} (${window.location.origin}/users/${this.currentUser.id}) waved at you!` +
          ` They live ${this.distanceBetweenUsers(targetUser)} mi. away${this.messageChildAgeString}.` +
          ` If you're interested in a playdate, reply here!`
      }
    },
    acknowledgeMessage () {
      return (targetUser) => {
        if (!targetUser) { return '' }
        return `We just sent your wave to ${targetUser.firstName}` +
          ` (${window.location.origin}/users/${targetUser.id}).` +
          ` Reply here to introduce yourself and schedule your first playdate!`
      }
    },
    distanceBetweenUsers () {
      return function (targetUser) {
        const targetLocation = targetUser.location
        return this.distanceFromCurrentUser(targetLocation.lat, targetLocation.lng)
      }
    },
    ...mapGetters([ 'currentUser', 'pendingWaves', 'distanceFromCurrentUser' ])
  },
  methods: {
    async settlePendingWaves () {
      for (let targetUser of this.pendingWaves) {
        try {
          await initProxySession(
            this.currentUser.id,
            targetUser.id,
            this.meetMessage(targetUser),
            this.acknowledgeMessage(targetUser)
          )
        } catch (e) {
          console.error(e)
          this.showBriefAllert('There was a problem sending your message.  Please try again later', 'failure')
        } finally {
          // mark the wave as send even if it fails
          this.$store.commit('removePendingWave', { targetUserId: targetUser.id })
        }
      }
    }

  }
}
