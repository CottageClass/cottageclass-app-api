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
          title="Why can't you come to this playdate?"
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
import Nav from '@/components/FTE/Nav'
import StyleWrapper from '@/components/FTE/StyleWrapper'
import Checkboxes from '@/components/base/Checkboxes.vue'
import Question from '@/components/base/Question.vue'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'

import { submitToSheetsu } from '@/utils/vendor/sheetsu'
import { mapGetters, mapMutations } from 'vuex'
import { alerts } from '@/mixins'

export default {
  name: 'DeclineRSVP',
  components: { StyleWrapper, Nav, Checkboxes, Question, FormWithTextArea },
  data () {
    return {
      otherText: '',
      reasons: []
    }
  },
  mixins: [alerts],
  props: ['eventId'],
  computed: {
    labelsAndOrder () {
      return [
        [ 'moreInfo', 'Need more info about the other parent.' ],
        [ 'tooFar', 'It\'s too far away.' ],
        [ 'incompatibleAges', 'Ages didn\'t seem compatible.' ],
        [ 'badTime', 'That time never works for me.' ],
        [ 'badDay', 'That day of the week never works.' ],
        [ 'badDayTime', 'This specific date & time doesn\'t work.' ]
      ]
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    submit () {
      submitToSheetsu({
        userId: this.currentUser.id,
        eventId: this.eventId,
        reasons: this.reasons,
        otherText: this.otherText }, 'noRsvp')
      this.showAlertOnNextRoute('Thanks for your feedback! Here are some other options you might like...', 'success')
      this.declineRsvp({ eventId: this.eventId })
      this.$router.push({ name: 'Search' })
    },
    ...mapMutations(['declineRsvp'])
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
