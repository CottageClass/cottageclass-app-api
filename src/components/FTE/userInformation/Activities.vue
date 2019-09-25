<template>
  <Question
    title="What are your interests?"
    subtitle="Pick some favorite interests and activities (things you like to do as a family) to find other families with common interests."
  >
    <Checkboxes
      :labels="[['travel', 'Travel' ], ['team sports', 'Team sports'], ['puzzles & games', 'Puzzles & games'], ['art & drawing', 'Art & drawing'], ['computers', 'Computers'], ['music', 'Music'], ['dance', 'Dance'], ['theater', 'Theater'], ['gardening', 'Gardening'], ['activism', 'Activism'], ['reading books', 'Reading books'], ['camping', 'Camping'], ['hiking', 'Hiking'], ['bike rides', 'Bike rides'], ['road trips', 'Road trips'], ['museums', 'Museums']]"
      v-model="activitiesChosen" />
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import Checkboxes from '@/components/base/Checkboxes.vue'

export default {
  name: 'Activities',
  components: { Question, Checkboxes },
  props: ['value'],
  data () {
    return {
      activitiesChosen: this.value
    }
  },
  watch: {
    activitiesChosen: function () {
      this.$emit('input', this.activitiesChosen)
    }
  }
}
</script>
