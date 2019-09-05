import { unstarUser, starUser, darkStarUser, undarkStarUser } from '@/utils/api'
import { trackEvent } from '@/utils/vendor/ahoy'

export default {
  methods: {
    async starUser (userId, context) {
      try {
        await starUser(userId)
        await this.$ga.event('Star', 'added - ' + context, userId)
        await trackEvent('star_added', {
          context,
          userId
        })
      } catch (err) {
        throw err
      }
    },
    async unstarUser (userId, context) {
      try {
        await unstarUser(userId)
        await this.$ga.event('Star', 'removed - ' + context, userId)
        await trackEvent('star_removed', {
          context,
          userId
        })
      } catch (err) {
        throw err
      }
    },
    async darkStarUser (userId, context) {
      try {
        await darkStarUser(userId)
        await this.$ga.event('DarkStar', 'added - ' + context, userId)
        await trackEvent('dark_star_added', {
          context,
          userId
        })
      } catch (err) {
        throw err
      }
    },
    async undarkStarUser (userId, context) {
      try {
        await undarkStarUser(userId)
        await this.$ga.event('DarkStar', 'removed - ' + context, userId)
        await trackEvent('dark_star_removed', {
          context,
          userId
        })
      } catch (err) {
        throw err
      }
    }
  }
}
