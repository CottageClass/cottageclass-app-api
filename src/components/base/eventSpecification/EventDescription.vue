<template>
  <Question
    title="Describe Offer"
    subtitle="What would you like to propose to other families? A picnic in the park? A playdate at your house? It's up to you. (You'll choose the times on the next step.)">
    <FormWithTextArea
      placeholder="Going to the park with my4 and 6 year olds to burn off some energy"
      v-model="description" />
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'
export default {
  name: 'EventDescription',
  components: { Question, FormWithTextArea },
  props: ['value'],
  data () {
    return {
      description: this.value.text,
      err: false
    }
  },
  watch: {
    rules: function () {
      this.$emit('input', { err: this.err, text: this.rules })
    }
  }
}
</script>
