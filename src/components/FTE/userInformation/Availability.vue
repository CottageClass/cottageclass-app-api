<template>
  <Question
    title="When are you usually available to meet other parents?"
    subtitle="This information helps us match you with parents who have compatible schedules." >
    <Checkboxes
      v-model="checkedAvailabilityIds"
      :labels="labelsAndOrder"/>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import Checkboxes from '@/components/base/Checkboxes.vue'

export default {
  name: 'Availability',
  props: ['value'],
  components: { Question, Checkboxes },
  data () {
    return {
      checkedAvailabilityIds: [],
      labelsAndOrder: [
        [ 'availableMornings', 'Weekday mornings' ],
        [ 'availableAfternoons', 'Weekday afternoons' ],
        [ 'availableEvenings', 'Weekday evenings' ],
        [ 'availableWeekends', 'Weekends' ]
      ]
    }
  },
  watch: {
    availability: function () {
      this.$emit('input', this.availability)
    }
  },
  computed: {
    availability: function () {
      const that = this
      // this converts our array of checkedBoxes to an object with true/false for each id
      const a = that.labelsAndOrder.reduce(
        function (res, idAndLabel, index) {
          const id = idAndLabel[0]
          return { ...res, ...{ [id]: that.checkedAvailabilityIds.includes(id) } }
        },
        {})
      return a
    }
  },
  mounted: function () {
    this.checkedAvailabilityIds = []
    for (let k in this.value) {
      if (this.value[k]) {
        this.checkedAvailabilityIds.push(k)
      }
    }
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
