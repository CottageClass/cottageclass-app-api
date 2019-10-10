<template>
  <Question
    title="Describe your playdate"
    subtitle="Be sure to include a short description of what you'd like to do or, if you're meeting in a public place, what the plan will be.">
    <FormWithTextArea
      class="short"
      maxLength="255"
      placeholder="What is your playdate's name e.g. 'Storytime at the Brooklyn Public library'"
      v-model="name" />
    <FormWithTextArea
      class="tall"
      maxLength="30,000"
      placeholder="Describe your playdate here, e.g. 'We have been here several times and it's lots of fun!'"
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
      name: this.value.name,
      description: this.value.description,
      defaultSubtitle: "Describe a playdate you'd like to host in your home or public space. It can be a one-time event (like a trip to the zoo) or something you can offer on a regular basis, like arts & crafts, indoor play, or a playground hangout!"
    }
  },
  methods: {
    emitData () {
      this.$emit('input', {
        err: this.errorMessage,
        name: this.name,
        description: this.description
      })
    }
  },
  computed: {
    errorMessage () {
      return (this.name && this.name.length >= 1) ? null : 'Please enter a name for your playdate.'
    }
  },
  created () {
    this.emitData()
  },
  watch: {
    description: function () {
      this.emitData()
    },
    name: function () {
      this.emitData()
    }
  }
}
</script>
