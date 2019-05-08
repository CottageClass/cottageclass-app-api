<template>
  <Question
    title="Tell us a bit about yourself"
    subtitle="Other members would love to know a bit more about you and your family.">
    <FormWithTextArea
      v-model="profileBlurb"
      placeholder="Your illustrious biography"
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
