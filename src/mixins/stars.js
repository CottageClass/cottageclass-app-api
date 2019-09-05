import { unstarUser, starUser, darkStarUser, undarkStarUser } from '@/utils/api'
import { trackEvent } from '@/utils/vendor/ahoy'

export default {
  methods: {
    starUser (userId, context) {
      return starUser(userId).then(res => {
        this.$ga.event('Star', 'added - ' + context, userId)
        trackEvent('star_added', {
          context,
          userId
        })
        return res
      })
    },
    unstarUser (userId, context) {
      return unstarUser(userId).then(res => {
        this.$ga.event('Star', 'removed - ' + context, userId)
        trackEvent('star_removed', {
          context,
          userId
        })
        return res
      })
    },
    darkStarUser (userId, context) {
      return darkStarUser(userId).then(res => {
        this.$ga.event('DarkStar', 'added - ' + context, userId)
        trackEvent('dark_star_added', {
          context,
          userId
        })
        return res
      })
    },
    undarkStarUser (userId, context) {
      return undarkStarUser(userId).then(res => {
        this.$ga.event('DarkStar', 'removed - ' + context, userId)
        trackEvent('dark_star_removed', {
          context,
          userId
        })
        return res
      })
    }
  }
}
