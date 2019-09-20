<template>
  <Question
    :title="titleForContext"
    :subtitle="subtitleForContext">
    <FormWithTextArea
      maxLength="5000"
      placeholder="Describe your playdate here, e.g. 'Come over and play at our house!'"
      v-model="description" />
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'

export default {
  name: 'EventDescription',
  components: { Question, FormWithTextArea },
  props: ['value', 'context'],
  data () {
    return {
      description: this.value.text,
      defaultSubtitle: "Describe a playdate you'd like to host in your home or public space. It can be a one-time event (like a trip to the zoo) or something you can offer on a regular basis, like arts & crafts, indoor play, or a playground hangout!"
    }
  },
  computed: {
    errorMessage () {
      return (this.description && this.description.length >= 1) ? null : 'Please enter a description of your offer'
    },
    titleForContext () {
      if (this.context === 'request-childcare') {
        return 'To request care, first offer a playdate.'
      } else {
        return 'Offer a playdate'
      }
    },
    subtitleForContext () {
      if (this.context === 'onboarding') { // "onboarding", "request-childcare", "new-event"
        return this.defaultSubtitle + " (You can skip this step if you're not ready.)"
      } else if (this.context === 'request-childcare') {
        return 'We ask that you offer a playdate first, so that parents can meet you before providing childcare. ' + this.defaultSubtitle
      } else {
        return this.defaultSubtitle
      }
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
