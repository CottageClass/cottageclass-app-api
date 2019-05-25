<template>
  <Question
  title="How many weeks would you like to repeat your availability?"
  :explanation="subtitle">
  <div class="dropdown-container">
      <div>
        <select class="lp-select" v-model="repeatCount">
          <option>1</option>
          <option>2</option>
          <option>3</option>
          <option>4</option>
          <option>5</option>
          <option>6</option>
          <option>7</option>
          <option>8</option>
          <option>9</option>
          <option>10</option>
        </select>
      </div>
    </div>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'

export default {
  name: 'RepeatCount',
  components: { Question },
  props: ['value'],
  data () {
    return {
      repeatCount: this.value.number || 2
    }
  },
  computed: {
    subtitle () {
      return 'Your offerings will be posted for this many weeks.  If you need to adjust or cancel one, you can do so at any time.'
    }
  },
  mounted: function () {
    this.$emit('input', { err: null, number: this.repeatCount })
  },
  watch: {
    repeatCount: {
      handler: function () {
        this.$emit('input', { err: null, number: this.repeatCount })
      },
      deep: true
    }
  }
}

</script>
