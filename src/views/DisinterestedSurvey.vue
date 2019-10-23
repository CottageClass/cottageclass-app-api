<template>
  <div class="onb-body">
    <Nav
      button="done"
      @next="submit"
      :hidePrevious="true"
    />
    <div class="content-wrapper">
      <StyleWrapper styleIs="onboarding">
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
      </StyleWrapper>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

import Nav from '@/components/FTE/Nav'
import StyleWrapper from '@/components/FTE/StyleWrapper'
import Checkboxes from '@/components/base/Checkboxes.vue'
import Question from '@/components/base/Question.vue'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'

import { submitToSheetsu } from '@/utils/vendor/sheetsu'
import { alerts, goHome } from '@/mixins'
import { fetchUser } from '@/utils/api'

export default {
  name: 'DisinterestedSurvey',
  components: { StyleWrapper, Nav, Checkboxes, Question, FormWithTextArea },
  data () {
    return {
      otherUser: null,
      otherText: '',
      reasons: []
    }
  },
  mixins: [ alerts, goHome],
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

<style scoped>

.onb-body {
  background-color: #0d73c7;
}

.content-wrapper {
  width: 720px;
  min-height: 100vh;
  margin-right: auto;
  margin-left: auto;
  padding-bottom: 50px;
  background-color: #1c8be7;
}
@media (max-width: 991px) {
  .content-wrapper {
    width: 670px;
  }
}

@media (max-width: 767px) {
  .content-wrapper {
    width: 100%;
    margin-top: 0px;
    margin-bottom: 0px;
  }
}
</style>
