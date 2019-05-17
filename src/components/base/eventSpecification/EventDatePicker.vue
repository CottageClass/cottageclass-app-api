<template>
  <Question
    title="Choose a day for your monthly activity"
    subtitle="Activities repeat every 4 weeks on the same weekday, unless you change or cancel, so please pick a day when you're usually available. These are the days we need most:">
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
      dateSelected: '',
      errorMesg: 'Please choose a day for your activity.',
      otherDate: null
    }
  },
  mounted: function () {
    this.$emit('input', {
      err: this.errorMesg
    })
  },
  computed: {
    firstDate: function () {
      return moment().startOf('week').add(3, 'weeks').add(5, 'days')
    },
    datesAsMoments: function () {
      return [
        this.firstDate,
        this.firstDate.clone().add(1, 'days'),
        this.firstDate.clone().add(2, 'days'),
        this.firstDate.clone().add(1, 'weeks'),
        this.firstDate.clone().add(1, 'weeks').add(1, 'days'),
        this.firstDate.clone().add(1, 'weeks').add(2, 'days')
      ]
    },
    dates: function () {
      return [...this.datesAsMoments.map(date => date.format('YYYY-MM-DD')), 'Other']
    },
    err: function () {
      if (!this.dateSelected || (this.dateSelected === 'Other' && !this.dateIsValid(this.otherDate))) {
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
      return moment(date).isAfter(new Date()) && moment(date).isBefore(yearFromNow)
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
    },
    displayDate: function (date) {
      return moment(date).format('dddd, MMMM Do')
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
