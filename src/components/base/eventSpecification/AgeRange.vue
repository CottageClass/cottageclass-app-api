<template>
  <Question title="What ages are welcome?" subtitle="Select the youngest and oldest children you can host. Try to be as flexible as possible.">
    <form class="age-range-form">
     <Dropdown v-model="minimum" :choices="choices"/>
      <div class="en-dash-container">
        <div>-</div>
      </div>
      <Dropdown v-model="maximum" :choices="choices"/>
    </form>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import Dropdown from '@/components/Dropdown.vue'
export default {
  name: 'AgeRange',
  props: ['value'],
  components: { Question, Dropdown },
  data () {
    return {
      minimum: 0,
      maximum: 12,
      choices: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    }
  },
  computed: {
    err: function () {
      if (parseInt(this.value.minimum) > parseInt(this.value.maximum)) {
        return 'Oops, the minimum age is greater than the maximum age!'
      } else {
        return false
      }
    }
  },
  methods: {
    emitData: function () {
      this.$emit('input', {
        minimum: this.minimum,
        maximum: this.maximum,
        err: this.err
      })
    }
  },
  watch: {
    minimum: function () {
      this.emitData()
    },
    maximum: function () {
      this.emitData()
    }
  }
}
</script>
