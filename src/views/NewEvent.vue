<template>
  <div class="onb-body">
    <div class="content-wrapper">
      <Nav
        :button="nextButtonState"
        @next="nextStep"
        @prev="prevStep"
        :hidePrevious="currentIndex===0"
      />
      <StyleWrapper styleIs="onboarding">
        <ErrorMessage v-if="err && showError" :text="err" />
        <EventDescription
            v-if="currentStep==='description'"
            v-model="event.description" />
          <MultipleTimeSelector
            v-if="currentStep==='time'"
            :firstDisplay="110"
            :value="event.availability"
            />
          <EventDatePicker
            v-if="currentStep==='date'"
            v-model="event.date" />
      </StyleWrapper>
    </div>
  </div>
</template>

<script>
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import EventDescription from '@/components/base/eventSpecification/EventDescription'
import MultipleTimeSelector from '@/components/base/eventSpecification/MultipleTimeSelector.vue'
import EventDatePicker from '@/components/base/eventSpecification/EventDatePicker.vue'
import StyleWrapper from '@/components/FTE/StyleWrapper'
import Nav from '@/components/FTE/Nav'

import { submitEventSeriesData } from '@/utils/api'
import moment from 'moment'
import { localWeekHourToMoment } from '@/utils/time'
import { mapGetters, mapMutations } from 'vuex'

const stepSequence = ['description', 'time', 'date']

export default {
  name: 'NewEvent',
  components: { EventDescription, StyleWrapper, Nav, MultipleTimeSelector, EventDatePicker, ErrorMessage },
  data () {
    return {
      showError: false,
      stepIndex: 0,
      event: null
    }
  },
  computed: {
    modelForCurrentStep () {
      const models = {
        description: this.event.description,
        availability: this.event.availability,
        date: this.event.date
      }
      return models[this.currentStep]
    },
    err () {
      return this.modelForCurrentStep && this.modelForCurrentStep.err
    },
    currentStep () {
      return this.$route.params.step
    },
    currentIndex () {
      return stepSequence.findIndex(e => e === this.currentStep)
    },
    nextButtonState () {
      if (!this.modelForCurrentStep) {
        return 'inactive'
      }
      if (this.modelForCurrentStep.err) {
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
      if (this.firstCreatedEvent) {
        this.$router.push({ name: 'SocialInvite', params: { id: this.firstCreatedEvent.id, context: 'newEvent' } })
      } else {
        this.$router.push({ name: 'Events' })
      }
    },
    nextStep () {
      if (this.err) {
        this.showError = true
      } else {
        // state is persisted after route update because component is reused
        this.showError = false
        if (this.currentIndex === stepSequence.length - 1) {
          this.submitEvent()
        } else {
          this.$router.push({ name: 'NewEventStep', params: { step: stepSequence[this.currentIndex + 1] } })
        }
      }
    },
    prevStep () {
      if (this.currentIndex > 0) {
        this.$router.push({ name: 'NewEventStep', params: { step: stepSequence[this.currentIndex - 1] } })
      }
    },
    ...mapMutations([ 'setWipEvent', 'resetWipEvent', 'setCreatedEvents' ])
  },
  watch: {
    event: {
      handler () {
        this.setWipEvent({ event: this.event })
      },
      deep: true
    }
  },
  created () {
    if (!this.currentStep) {
      this.$router.push({ name: 'NewEventStep', params: { step: stepSequence[0] } })
    }
    this.event = this.wipEvent
    if (!this.event.availability.availability) {
      this.$set(this.event.availability, 'availability', [])
      for (let day = 0; day < 7; day++) {
        const row = []
        for (let hour = 0; hour < 24; hour++) {
          row.push(false)
        }
        this.event.availability.availability.push(row)
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
