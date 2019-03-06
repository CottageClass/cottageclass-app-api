<template>
 <Question
   title="When are you available for childcare in a pinch?"
   subtitle="Other parents may text you to request care during the times you choose. There's never any obligation to respond, so just pick times when you're usually available to provide care."
   explanation="You'll be able to accept or decline any requests. Most families list days and times that they are generally at home with their own children or doing a fun or educational activity which they'd like to include other children in.">
   <MultipleChoice
     type="checkbox"
     v-model="availability"
     :labelsAndOrder="labelsAndOrder"/>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import MultipleChoice from '@/components/base/MultipleChoice.vue'

export default {

  name: 'Availability',
  props: ['value'],
  components: { Question, MultipleChoice },
  data () {
    return {
      labelsAndOrder: [
        [ 'availableMornings', '9am - 3pm' ],
        [ 'availableAfternoons', '3pm - 7pm' ],
        [ 'availableEvenings', 'After 7pm' ],
        [ 'availableWeekends', 'Weekends' ]
      ]
    }
  },
  watch: {
    availability: {
      handler: function () {
        this.availability.err = false
        this.$emit('input', this.availability)
      },
      deep: true
    }
  },
  computed: {
    availability: function () { return this.value }
  }
}
</script>

<style lang="scss" scoped>

.onb-content-container {
  height: unset;
  min-height: 100%;
}

.onb-checkbox {
    margin-top: 22px;
}

</style>
