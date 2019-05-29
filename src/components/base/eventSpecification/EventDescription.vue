<template>
  <Question
    title="Offer a playdate"
    subtitle="Describe a playdate you'd like to host in your home or public space. It can be a one-time event (like a trip to the zoo) or something you can offer on a regular basis, like arts & crafts, indoor play, or a playground hangout!">
    <FormWithTextArea
      maxLength="120"
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
  props: ['value'],
  data () {
    return {
      description: this.value.text
    }
  },
  computed: {
    errorMessage () {
      return (this.description && this.description.length > 5) ? null : 'Please enter a description of your offer'
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
