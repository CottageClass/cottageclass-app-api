<template>
  <Question
  title="For how many weeks?"
  subtitle="How many weeks should the times you just provided repeat for? If your schedule is very predictable, repeat for several weeks. If not, don't repeat at all—it's up to you!">
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
