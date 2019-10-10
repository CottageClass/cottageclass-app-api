<template>
  <Question title="What ages are welcome?" subtitle="Select the youngest and oldest children you can host. Try to be as flexible as possible.">
    <form class="age-range-form">
      <Dropdown v-model="minimum" :choices="minChoices"/>
      <div class="en-dash-container">
        <div>-</div>
      </div>
      <Dropdown v-model="maximum" :choices="maxChoices"/>
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
      maximum: 12
    }
  },
  computed: {
    minChoices () {
      return range(0, this.maximum + 1)
    },
    maxChoices () {
      return range(this.minimum, 13)
    },
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

function range (min, max) {
  const res = []
  for (let i = min; i < max; i++) {
    res.push(i)
  }
  return res
}
</script>

<style lang="scss">
select.select-field {
  width: 50px;
}
</style>
