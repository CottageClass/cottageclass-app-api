import { mapGetters } from 'vuex'

import { childAgeSentenceText } from '@/utils/utils'
import { alerts } from '@/mixins'

export default {
  mixins: [ alerts ],
  computed: {
    messageChildAgeString () {
      const childAgesInMonths = this.currentUser.childAgesInMonths
      return childAgeSentenceText({ childAgesInMonths })
    },
    distanceBetweenUsers () {
      return function (targetUser) {
        return this.distanceFromCurrentUser(targetUser.place.fuzzyLatitude, targetUser.place.fuzzyLongitude)
      }
    },
    ...mapGetters([ 'currentUser', 'distanceFromCurrentUser' ])
  }
}
