<template>
  <Question
    title="What ages are welcome?"
    subtitle="Who is this playdate for? Select the minimum and maximum ages that would be compatible with this playdate.">
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
  props: ['value', 'childAgesInMonths'],
  components: { Question, Dropdown },
  data () {
    return {
      minimum: null,
      maximum: null
    }
  },
  created () {
    if (!this.value.minimum && this.value.minimum !== 0) {
      if (!this.childAgesInMonths) {
        this.minimum = 0
      } else {
        let minAgeInYearsRoundedDown = Math.floor(Math.min(...this.childAgesInMonths) / 12 - 1)
        this.minimum = Math.max(minAgeInYearsRoundedDown, 0)
      }
    }
    if (!this.value.maximum && this.value.maximum !== 0) {
      if (!this.childAgesInMonths) {
        this.maximum = 0
      } else {
        let maxAgeInYearsRounded = Math.round(Math.max(...this.childAgesInMonths) / 12) + 1
        this.maximum = Math.min(maxAgeInYearsRounded, 18)
      }
    }
  },
  computed: {
    choices () {
      return range(0, 19)
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
    value: {
      handler () {
        this.minimum = this.value.minimum || 0
        this.maximum = this.value.maximum || (this.value.maximum === 0 ? 0 : 18)
      },
      deep: true,
      immediate: true
    },
    minimum: function () {
      console.log(this.minimum, this.maximum, Math.max(this.maximum, this.minimum))
      this.maximum = Math.max(this.maximum, this.minimum)
      console.log(this.maximum)
      this.emitData()
    },
    maximum: function () {
      this.minimum = Math.min(this.maximum, this.minimum)
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
  .age-range-form {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
}

  .en-dash-container {
    margin: inherit;
    display: flex;
    padding-right: 8px;
    padding-left: 8px;
    padding-bottom: 10px;
    flex-direction: row;
    justify-content: center;
    align-items: flex-start;
  }

</style>
