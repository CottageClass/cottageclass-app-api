<template>
  <div>
    <Question
      :title="`Why aren't you interested in a playdate with ${this.otherUser.firstName}?`"
      subtitle="Your feedback is private and helps us do a better job of matching parents and playdates!" >
      <Checkboxes
        v-model="reasons"
        :labels="labelsAndOrder"/>
      <FormWithTextArea
        placeholder="Other reasons? Any notes to add?"
        v-model="otherText" />
    </Question>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

import Checkboxes from '@/components/base/Checkboxes.vue'
import Question from '@/components/base/Question.vue'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'

import { submitToSheetsu } from '@/utils/vendor/sheetsu'
import { alerts, goHome } from '@/mixins'
import { fetchUser } from '@/utils/api'

export default {
  name: 'DisinterestedSurvey',
  components: { Checkboxes, Question, FormWithTextArea },
  data () {
    return {
      otherUser: null,
      otherText: '',
      reasons: []
    }
  },
  mixins: [ alerts, goHome ],
  props: ['userId'],
  computed: {
    labelsAndOrder () {
      return [
        [ 'moreInfo', 'Need more info about the other parent.' ],
        [ 'tooFar', 'It\'s too far away.' ],
        [ 'incompatibleAges', 'Ages didn\'t seem compatible.' ],
        [ 'badType', 'Didn\'t seem my type.' ]
      ]
    },
    ...mapGetters(['currentUser', 'distanceFromCurrentUser'])
  },
  async created () {
    this.$emit('set-nav-props', {
      button: 'done',
      nextButtonHandler: this.submit.bind(this),
      hidePrevious: true
    })
    this.otherUser = await fetchUser(this.userId)
  },
  methods: {
    submit () {
      submitToSheetsu({
        respondantId: this.currentUser.id,
        respondantAgesInMonths: this.currentUser.childAgesInMonths,
        otherUserId: this.userId,
        otherUserAgesInMonths: this.otherUser.childAgesInMonths,
        distanceBetweenUsers: this.distanceFromCurrentUser(
          this.otherUser.place.latitude,
          this.otherUser.place.longitude
        ),
        reasons: this.reasons,
        otherText: this.otherText }, 'darkStars')
      this.showAlertOnNextRoute('Thank you for your feedback.', 'success')
      this.goHome()
    }
  }
}
</script>
