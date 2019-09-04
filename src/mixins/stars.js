import { unstarUser, starUser, darkStarUser, undarkStarUser } from '@/utils/api'

export default {
  methods: {
    starUser (userId, context) {
      return starUser(userId).then(res => {
        this.$ga.event('Star', 'added - ' + context, userId)
        return res
      })
    },
    unstarUser (userId, context) {
      return unstarUser(userId).then(res => {
        this.$ga.event('Star', 'removed - ' + context, userId)
        return res
      })
    },
    darkStarUser (userId, context) {
      return darkStarUser(userId).then(res => {
        this.$ga.event('DarkStar', 'added - ' + context, userId)
        return res
      })
    },
    undarkStarUser (userId, context) {
      return undarkStarUser(userId).then(res => {
        this.$ga.event('DarkStar', 'removed - ' + context, userId)
        return res
      })
    }
  }
}
