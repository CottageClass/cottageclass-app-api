<template>
  <Question
    title="Pick a date"
    subtitle="When will this playdate occur? (For recurring playdates, please select the day of the first playdate in the series)">
    <div class="picker-container" >
      <v-date-picker class="date-picker"
                     color="#fc6f77"
                     :allowedDates="allowedDates"
                     v-model="dateSelected" />
    </div>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
var moment = require('moment')

export default {
  name: 'EventDatePicker',
  props: ['value'],
  components: { Question },
  data () {
    return {
      dateSelected: this.value.selected || '',
      errorMessage: 'Please choose a day for your activity.'
    }
  },
  mounted: function () {
    this.emitDate()
  },
  computed: {
    err: function () {
      if (!this.dateSelected) {
        return this.errorMessage
      } else {
        return false
      }
    }
  },
  watch: {
    dateSelected: function () {
      this.emitDate()
    }
  },
  methods: {
    allowedDates (date) {
      const yearFromNow = moment(new Date()).add(1, 'years')
      const yesterday = moment(new Date()).add(-1, 'days')
      return moment(date).isAfter(yesterday) && moment(date).isBefore(yearFromNow)
    },
    emitDate: function () {
      this.$emit('input', {
        selected: this.dateSelected,
        err: this.err
      })
    },
    dateIsValid: function (date) {
    // for now we just make them enter something
      return !!date
    }
  }
}
</script>

<style scoped lang="scss">
.flow {
  .picker-container {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
}
</style>
