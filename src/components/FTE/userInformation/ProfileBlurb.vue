<template>
  <Question
    title="Tell us a bit about yourself"
    subtitle="To help us find you playdates, we need a short paragraph about your family (and what you're looking for here) that we can show to other parents.">
    <FormWithTextArea
      v-model="profileBlurb"
      placeholder="e.g. 'We love parks and playgrounds, and we're looking for playdates on the weekend!'"
      rows="4"
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
      profileBlurb: this.value.text
    }
  },
  computed: {
    errorMessage () {
      return (this.profileBlurb && this.profileBlurb.length >= 1) ? null : 'Please tell us a little about yourself'
    }
  },
  created () {
    this.$emit('input', { err: this.errorMessage, text: this.profileBlurb })
  },
  watch: {
    profileBlurb: function () {
      this.$emit('input', { err: this.errorMessage, text: this.profileBlurb })
    }
  }
}
</script>
