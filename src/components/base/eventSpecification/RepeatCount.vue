<template>
  <Question
    title="How many weeks will it repeat for?"
    subtitle="How many weeks should this playdate repeat for? If the schedule is very predictable, repeat for several weeks. If not, just choose 1 week (that means it only happens once). For playdates in public places, it's okay if you aren't going to every session">
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
      repeatCount: this.value.number || 1
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
<style lang="scss" scoped>
  .dropdown-container {
    text-align: center;
    font-size: 24px;
    padding: 0 0 16px 0;
  }
</style>
