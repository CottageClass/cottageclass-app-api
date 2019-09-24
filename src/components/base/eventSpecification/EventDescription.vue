<template>
  <Question
    title="Describe your playdate"
    subtitle="Be sure to include a short description of what you'd like to do or, if you're meeting in a public place, what the plan will be.">
    <FormWithTextArea
      maxLength="5000"
      placeholder="Describe your playdate here, e.g. 'Let's go to the playground this afternoon!'"
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
      defaultSubtitle: "Describe a playdate you'd like to host in your home or public space. It can be a one-time event (like a trip to the zoo) or something you can offer on a regular basis, like arts & crafts, indoor play, or a playground hangout!"
    }
  },
  computed: {
    errorMessage () {
      return (this.description && this.description.length >= 1) ? null : 'Please enter a description of your playdate'
    }
  },
  created () {
    this.$emit('input', { err: this.errorMessage, text: this.description })
  },
  watch: {
    description: function () {
      this.$emit('input', { err: this.errorMessage, text: this.description })
    }
  }
}
</script>
