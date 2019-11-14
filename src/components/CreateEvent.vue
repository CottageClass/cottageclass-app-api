<template>
  <div>
    <LoadingSpinner v-if="submissionPending" />
    <EventPlace
      v-else-if="stepName==='place'"
      v-model="place" />
    <EventDatePicker
      v-else-if="stepName==='date'"
      v-model="date" />
    <EventTime
      v-else-if="stepName==='time'"
      v-model="time" />
    <AgeRange
      v-else-if="stepName==='age-range'"
      v-model="ageRange"
      :childAgesInMonths="currentUser.childAgesInMonths"
    />
    <RepeatCount
      v-else-if="stepName==='repeat-count'"
      v-model="repeatCount"
    />
    <EventOverview
      v-else-if="stepName==='description'"
      :public="isPublic"
      v-model="description" />
  </div>
</template>

<script>
import LoadingSpinner from '@/components/LoadingSpinner'
import RepeatCount from '@/components/base/eventSpecification/RepeatCount'
import EventDatePicker from '@/components/base/eventSpecification/EventDatePicker'
import EventTime from '@/components/base/eventSpecification/EventTime'
import EventOverview from '@/components/base/eventSpecification/EventOverview'
import EventPlace from '@/components/base/eventSpecification/EventPlace'
import AgeRange from '@/components/base/eventSpecification/AgeRange.vue'

import { submitEventSeriesData } from '@/utils/api'
import moment from 'moment'
import { localWeekHourToMoment } from '@/utils/time'
import { mapGetters } from 'vuex'

import { stepNavigation, alerts } from '@/mixins'

export default {
  name: 'CreateEvent',
  components: { EventOverview, EventPlace, EventDatePicker, EventTime, RepeatCount, LoadingSpinner, AgeRange },
  mixins: [stepNavigation, alerts],
  props: ['stepName', 'context'],
  data () {
    return {
      submissionPending: false,
      place: { err: null },
      description: { err: null, name: '', description: '' },
      repeatCount: { err: null },
      date: { err: null },
      time: { err: null },
      ageRange: {}
    }
  },
  computed: {
    isPublic () {
      if (this.place.public === true) { return true } else { return false }
    },
    isOnLastStep () {
      return this.stepName === this.lastStep
    },
    lastStep () {
      return this.stepSequence[this.stepSequence.length - 1]
    },
    stepSequence () {
      return [ 'place', 'date', 'time', 'age-range', 'repeat-count', 'description' ]
    },
    scheduleStart () {
      return moment()
    },
    modelForCurrentStep () {
      const models = {
        description: this.description,
        place: this.place,
        date: this.date,
        time: this.time
      }
      return models[this.stepName]
    },
    eventSeriesDataForSubmission () {
      return (timeRange) => {
        return {
          'event_series': {
            'name': this.description.name,
            'description': this.description.description,
            'images': this.description.images,
            'start_date': timeRange.start.format('YYYY-MM-DD'),
            'starts_at': timeRange.start.format('HH:mm'),
            'ends_at': timeRange.end.format('HH:mm'),
            'maximum_children': 4,
            'child_age_minimum': this.ageRange.minimum,
            'child_age_maximum': this.ageRange.maximum,
            'repeat_for': this.repeatCount.number || 1,
            'interval': 1,
            'placeAttributes': this.place
          }
        }
      }
    },
    timeRangeForBlock () {
      return ([startHour, endHour]) => {
        const start = localWeekHourToMoment(startHour, moment())
        const end = localWeekHourToMoment(endHour, start)
        return { start, end }
      }
    },
    ...mapGetters([ 'currentUser', 'firstCreatedEvent' ])
  },
  methods: {
    finished: function () {
      if (this.place.public) {
        this.$emit('finishedPublicEvent')
      } else {
        this.$emit('finishedHomeEvent')
      }
    },
    selectDateAndTime () {
      this.$router.push({ params: { stepName: 'date' } })
    },
    async submitSpecificEvent () {
      this.submissionPending = true
      try {
        const start = moment(this.date.selected + 'T' + this.time.start)
        const end = moment(this.date.selected + 'T' + this.time.end)
        const timeRange = { start, end }
        const res = await submitEventSeriesData(this.eventSeriesDataForSubmission(timeRange))
        this.$emit('submission-complete', res)
      } catch (e) {
        this.logError('Failed to submit event series')
        this.logError(e)
        this.showAlert('Sorry, there was a problem submitting your event.  Please try again later', 'failure')
      }
      this.finished()
    },
    async nextStep () {
      if (this.nextButtonState === 'skip') {
        this.$emit('skip')
      } else {
        // state is persisted after route update because component is reused
        if (this.isOnLastStep) {
          await this.submitSpecificEvent()
        } else {
          this.$router.push({
            params: { stepName: this.stepSequence[this.stepIndex + 1] }
          })
        }
        this.trackStep('offering')
      }
    }
  },
  watch: {
    time: {
      handler () {
        this.lastTimeChosen = 'specific'
      },
      deep: true
    }
  },
  created () {
    this.event = this.wipEvent
  }
}
</script>

<style scoped>

.content-wrapper {
  width: 720px;
  min-height: 100vh;
  margin-right: auto;
  margin-left: auto;
  padding-bottom: 50px;
}

@media (max-width: 991px) {
  .content-wrapper {
    width: 670px;
  }
}

@media (max-width: 767px) {
  .content-wrapper {
    width: 100%;
    margin-top: 0px;
    margin-bottom: 0px;
  }
}
</style>
