<template>
  <Question
    title="Pick a date"
    subtitle="When would you like to offer this playdate?">
    <div class="picker-container" >
      <v-date-picker class="date-picker"
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
      errorMesg: 'Please choose a day for your activity.'
    }
  },
  mounted: function () {
    this.emitDate()
  },
  computed: {
    err: function () {
      if (!this.dateSelected) {
        return this.errorMesg
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

<style scoped>

p {
  color: white;
}

.describe-label {
  color: white;
  padding-top: 16px;
}

textarea {
  height: 96px;
}

.onb-content-container {
  min-height: 130vh;
}

</style>
