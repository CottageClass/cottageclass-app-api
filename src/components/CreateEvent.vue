<template>
  <div>
    <Nav
      :button="nextButtonState"
      @next="nextStep"
      @prev="prevStep"
      :hidePrevious="currentIndex===0"
    />
    <ErrorMessage v-if="errorMessage && showError" :text="errorMessage" />
    <EventDescription
        v-if="stepName==='description'"
        v-model="description" />
    <MultipleTimeSelector
      v-if="stepName==='availability'"
      :scheduleStartTime="scheduleStart"
      :value="availability"
      />
  </div>
</template>

<script>
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import EventDescription from '@/components/base/eventSpecification/EventDescription'
import MultipleTimeSelector from '@/components/base/eventSpecification/MultipleTimeSelector.vue'
import Nav from '@/components/FTE/Nav'

import { submitEventSeriesData } from '@/utils/api'
import moment from 'moment'
import { localWeekHourToMoment } from '@/utils/time'
import { mapGetters, mapMutations } from 'vuex'

import { stepNavigation } from '@/mixins'

export default {
  name: 'CreateEvent',
  components: { EventDescription, Nav, MultipleTimeSelector, ErrorMessage },
  mixins: [stepNavigation],
  props: ['stepName'],
  data () {
    return {
      showError: false,
      description: { err: null },
      availability: { err: null },
      stepIndex: 0
    }
  },
  computed: {
    stepSequence () {
      return ['description', 'availability']
    },
    scheduleStart () {
      return moment()
    },
    modelForCurrentStep () {
      const models = {
        description: this.description,
        availability: this.availability
      }
      return models[this.stepName]
    },
    currentIndex () {
      return this.stepSequence.findIndex(e => e === this.stepName)
    },
    errorMessage () {
      return this.modelForCurrentStep && this.modelForCurrentStep.err
    },
    nextButtonState () {
      if (this.errorMessage) {
        return 'inactive'
      } else {
        return 'next'
      }
    },
    eventSeriesDataForSubmission () {
      return (timeRange) => {
        return {
          'event_series': {
            'name': this.wipEvent.description.text,
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
            'repeat_for': 1
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
    async submitEvent () {
      this.debug(this.wipEventContiguousTimeBlocks)
      for (let contiguousTimeBlock of this.wipEventContiguousTimeBlocks.reverse()) {
        try {
          const timeRange = this.timeRangeForBlock(contiguousTimeBlock)
          const res = await submitEventSeriesData(this.eventSeriesDataForSubmission(timeRange))
          this.setCreatedEvents({ eventData: res })
        } catch (e) {
          this.logError('Failed to sumbit event series')
          this.logError(e)
          this.showAlert('Sorry, there was a problem submitting your event.  Please try again later', 'failure')
        }
      }
      this.resetWipEvent()
      this.$emit('finished')
    },
    nextStep () {
      if (this.errorMessage) {
        this.showError = true
      } else {
        // state is persisted after route update because component is reused
        this.showError = false
        if (this.currentIndex === this.stepSequence.length - 1) {
          this.submitEvent()
        } else {
          this.$router.push({
            params: { stepName: this.stepSequence[this.currentIndex + 1] }
          })
        }
      }
    },
    prevStep () {
      if (this.currentIndex > 0) {
        this.$router.push({ params: { stepName: this.stepSequence[this.currentIndex - 1] } })
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
