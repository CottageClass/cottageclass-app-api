<template>
  <Question
    title="Please describe your event"
    subtitle="Be descriptive and try to highlight the funnest parts!">
    <form v-on:submit.prevent>
      <input
        @keyup.enter="$emit('pressedEnter')"
        v-model="description"
        type="text"
        class="w-input location-text-field"
        maxlength="288">
    </form>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'

export default {
  name: 'EventDescription',
  props: ['value'],
  components: { Question },
  data () {
    return {
      description: this.value
    }
  },
  watch: {
    description: function () {
      this.$emit('input', this.description)
    }
  }
}
</script>
<style lang="scss" scoped src="@/assets/style/scss/editing.scss"></style>
