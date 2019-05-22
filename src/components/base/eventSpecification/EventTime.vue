<template>
  <Question
    :title="titleText"
    :subtitle="subtitleText">
    <RadioButtons
      v-model="timeSelected"
      :choices="times" />
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import RadioButtons from '@/components/base/RadioButtons.vue'

var moment = require('moment')

const TIMES = [
  '9:00am - 12:00pm',
  '11:00am - 2:00pm',
  '2:00pm - 5:00pm',
  '3:00pm - 6:00pm',
  '4:00pm - 7:00pm',
  '5:00pm - 8:00pm',
  '5:30pm - 8:30pm',
  '6:00pm - 9:00pm',
  '6:30pm - 9:30pm',
  '7:00pm - 10:00pm'
]

export default {
  name: 'EventTime',
  props: ['value', 'context'],
  components: { Question, RadioButtons },
  data () {
    return {
      timeSelected: null,
      errorMesg: 'Please choose a time for your playdate.'
    }
  },
  mounted: function () {
    this.timeSelected = this.startTimeChoice
    this.$emit('input', {
      start: this.startTime,
      end: this.endTime,
      err: this.errorMesg
    })
  },
  computed: {
    titleText () {
      return this.$route.name === 'NewEventStep' ? 'When are you available?' : 'Choose a time for your activity'
    },
    subtitleText () {
      return 'Each activity runs 3 hours in the evening, but the start time is up to you. (You\'ll choose the date next.)'
    },
    startTimeChoice () {
      if (!this.value.start) { return null }
      return TIMES.find(t => {
        return moment(t.split(' ')[0], 'h mm a').format('HH:mm') === moment(this.value.start, 'h mm a').format('HH:mm')
      })
    },
    times () {
      return TIMES
    },
    err: function () {
      if (!this.timeSelected) {
        return this.errorMesg
      } else {
        return false
      }
    },
    startTimeUnparsed: function () {
      if (!this.timeSelected) {
        return null
      }
      return this.timeSelected.split(' ')[0]
    },
    startTime: function () {
      return this.startTimeUnparsed ? moment(this.startTimeUnparsed, 'h mm a').format('HH:mm') : null
    },
    endTime: function () {
      return this.startTimeUnparsed ? moment(this.startTime, 'HH:mm').add(3, 'hours').format('HH:mm') : null
    }
  },
  watch: {
    timeSelected: function () {
      this.$emit('input', {
        start: this.startTime,
        end: this.endTime,
        err: this.err
      })
    }
  }
}
</script>

<style scoped>

.describe-label {
  color: white;
  padding-top: 16px;
}

textarea {
  height: 96px;
}

.onb-content-container {
  min-height: 100vh;
}

</style>
