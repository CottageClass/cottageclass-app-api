<template>
  <div>
    <Nav
      :button="nextButtonState"
      @next="nextStep"
      @prev="prevStep"
    />
    <ErrorMessage v-if="errorMessage && showError" :text="errorMessage" />
    <LoadingSpinner v-if="submissionPending" />
    <EventPlace
      v-else-if="stepName==='place'"
      v-model="place" />
    <EventDescription
      v-else-if="stepName==='description'"
      v-model="description" />
    <EventDatePicker
      v-else-if="stepName==='date'"
      v-model="date" />
    <EventTime
      v-else-if="stepName==='time'"
      v-model="time" />
    <MultipleTimeSelector
      v-else-if="stepName==='availability'"
      :scheduleStartTime="scheduleStart"
      :value="availability"
      @datetimeClicked="selectDateAndTime"
    />
    <RepeatCount
      v-else-if="stepName==='repeat-count'"
      v-model="repeatCount"
    />
  </div>
</template>

<script>
import LoadingSpinner from '@/components/LoadingSpinner'
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import RepeatCount from '@/components/base/eventSpecification/RepeatCount'
import EventDatePicker from '@/components/base/eventSpecification/EventDatePicker'
import EventTime from '@/components/base/eventSpecification/EventTime'
import EventDescription from '@/components/base/eventSpecification/EventDescription'
import EventPlace from '@/components/base/eventSpecification/EventPlace'
import MultipleTimeSelector from '@/components/base/eventSpecification/MultipleTimeSelector.vue'
import Nav from '@/components/FTE/Nav'

import { submitEventSeriesData, submitGooglePlaceIdAndFetchOurOwn } from '@/utils/api'
import moment from 'moment'
import { localWeekHourToMoment } from '@/utils/time'
import { mapGetters, mapMutations } from 'vuex'

import { stepNavigation, alerts } from '@/mixins'

export default {
  name: 'CreateEvent',
  components: { EventDescription, EventPlace, Nav, MultipleTimeSelector, ErrorMessage, EventDatePicker, EventTime, RepeatCount, LoadingSpinner },
  mixins: [stepNavigation, alerts],
  props: ['stepName', 'context'],
  data () {
    return {
      submissionPending: false,
      showError: false,
      place: { err: null },
      description: { err: null, text: '' },
      availability: { err: null },
      repeatCount: { err: null },
      date: { err: null },
      time: { err: null },
      ourPlaceId: null
    }
  },
  computed: {
    stepSequence () {
      return ['place', 'description', 'availability', 'repeat-count', 'date', 'time']
    },
    scheduleStart () {
      return moment()
    },
    modelForCurrentStep () {
      const models = {
        description: this.description,
        availability: this.availability,
        place: this.place
      }
      return models[this.stepName]
    },
    eventSeriesDataForSubmission () {
      return (timeRange) => {
        return {
          'event_series': {
            'name': this.description.text,
            'start_date': timeRange.start.format('YYYY-MM-DD'),
            'starts_at': timeRange.start.format('HH:mm'),
            'ends_at': timeRange.end.format('HH:mm'),
            'has_pet': false,
            'activity_names': [],
            'house_rules': '',
            'pet_description': '',
            'maximum_children': 4,
            'child_age_minimum': 0,
            'child_age_maximum': 18,
            'repeat_for': this.repeatCount.number || 1,
            'interval': 1,
            'place_id': this.ourPlaceId
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
    ...mapGetters([ 'currentUser', 'wipEvent', 'firstCreatedEvent', 'wipEventContiguousTimeBlocks' ])
  },
  methods: {
    finished: function () {
      this.ourPlaceId === null ? this.$emit('finishedHomeEvent') : this.$emit('finishedPublicEvent')
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
        await submitEventSeriesData(this.eventSeriesDataForSubmission(timeRange))
      } catch (e) {
        this.logError('Failed to submit event series')
        this.logError(e)
        this.showAlert('Sorry, there was a problem submitting your event.  Please try again later', 'failure')
      }
      this.resetWipEvent()
      this.finished()
    },
    async submitAvailabilityEvent () {
      this.submissionPending = true
      for (let contiguousTimeBlock of this.wipEventContiguousTimeBlocks.reverse()) {
        try {
          const timeRange = this.timeRangeForBlock(contiguousTimeBlock)
          const res = await submitEventSeriesData(this.eventSeriesDataForSubmission(timeRange))
          this.setCreatedEvents({ eventData: res })
        } catch (e) {
          this.logError('Failed to submit event series')
          this.logError(e)
          this.showAlert('Sorry, there was a problem submitting your event.  Please try again later', 'failure')
        }
      }
      this.resetWipEvent()
      this.finished()
    },
    async nextStep () {
      if (this.nextButtonState === 'skip') {
        this.$emit('skip')
      } else if (this.errorMessage) {
        this.showError = true
      } else {
        // state is persisted after route update because component is reused
        this.showError = false
        if (this.stepName === 'repeat-count' || this.stepName === 'time') {
          if (this.place.id !== null) {
            this.ourPlaceId = await submitGooglePlaceIdAndFetchOurOwn(this.place.id)
          }
        }
        if (this.stepName === 'repeat-count') {
          await this.submitAvailabilityEvent()
        } else if (this.stepName === 'time') {
          await this.submitSpecificEvent()
        } else {
          this.$router.push({
            params: { stepName: this.stepSequence[this.stepIndex + 1] }
          })
        }
        this.trackStep('offering')
      }
    },
    prevStep () {
      if (this.stepIndex > 0) {
        this.$router.replace({ params: { stepName: this.stepSequence[this.stepIndex - 1] } })
      } else {
        this.$router.go(-1)
      }
    },
    ...mapMutations([ 'setWipEvent', 'resetWipEvent', 'setCreatedEvents' ])
  },
  watch: {
    availability: {
      handler () {
        this.setWipEvent({ event: { availability: this.availability, description: this.description } })
      },
      deep: true
    }
  },
  created () {
    this.event = this.wipEvent
    if (!this.availability.availability) {
      this.$set(this.availability, 'availability', [])
      for (let day = 0; day < 7; day++) {
        const row = []
        for (let hour = 0; hour < 24; hour++) {
          row.push(false)
        }
        this.availability.availability.push(row)
      }
    }
  }
}
</script>

<style scoped>

.onb-body {
  background-color: #0d73c7;
}

.content-wrapper {
  width: 720px;
  min-height: 100vh;
  margin-right: auto;
  margin-left: auto;
  padding-bottom: 50px;
  background-color: #1c8be7;
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
