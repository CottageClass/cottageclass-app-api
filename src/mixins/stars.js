// mixin that wraps the api, event tracking and anything else that needs to happen every
// time stars are added or removed

import { starEventSeries, unstarEventSeries, darkStarUser, undarkStarUser } from '@/utils/api'
import { trackEvent } from '@/utils/ahoy'

export default {
  methods: {
    async starEventSeries (eventSeriesId, context) {
      try {
        const res = await starEventSeries(eventSeriesId)
        await trackEvent('star_added', {
          context,
          eventSeriesId
        })
        return res
      } catch (err) {
        throw err
      }
    },
    async unstarEventSeries (eventSeriesId, context) {
      try {
        const res = await unstarEventSeries(eventSeriesId)
        await trackEvent('star_removed', {
          context,
          eventSeriesId
        })
        return res
      } catch (err) {
        throw err
      }
    },
    async darkStarUser (userId, context) {
      try {
        const res = await darkStarUser(userId)
        await this.$ga.event('DarkStar', 'added - ' + context, userId)
        await trackEvent('dark_star_added', {
          context,
          userId
        })
        return res
      } catch (err) {
        throw err
      }
    },
    async undarkStarUser (userId, context) {
      try {
        const res = await undarkStarUser(userId)
        await this.$ga.event('DarkStar', 'removed - ' + context, userId)
        await trackEvent('dark_star_removed', {
          context,
          userId
        })
        return res
      } catch (err) {
        throw err
      }
    }
  }
}
