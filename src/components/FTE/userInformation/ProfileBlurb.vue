<template>
  <Question
    title="Tell us a bit about yourself"
    subtitle="To help us find you playdates, we need a short paragraph about your family (and what you're looking for here) that we can show to other parents.">
    <FormWithTextArea
      v-model="profileBlurb"
      placeholder="e.g. 'We love parks and playgrounds, and we're looking for playdates on the weekend!'"
      />
  </Question>
</template>

<script>

import FormWithTextArea from '@/components/base/FormWithTextArea.vue'
import Question from '@/components/base/Question.vue'

export default {
  name: 'ProfileBlurb',
  props: ['value'],
  components: { Question, FormWithTextArea },
  data () {
    return {
      profileBlurb: this.value
    }
  },
  watch: {
    profileBlurb: function () {
      this.$emit('input', this.profileBlurb)
    }
  }
}
</script>
