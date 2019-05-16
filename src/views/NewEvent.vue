<template>
  <div class="onb-body">
    <div class="content-wrapper">
      <Nav
        button="nextButtonState"
        @next="nextStep"
        @prev="prevStep"
        :hidePrevious="currentIndex===0"
      />
      <StyleWrapper styleIs="onboarding">
        <EventDescription
            v-if="currentStep==='description'"
          v-model="event.description" />
          <EventTime
            v-if="currentStep==='time'"
            v-model="event.time" />
          <EventDate
            v-if="currentStep==='date'"
            v-model="event.date" />
      </StyleWrapper>
    </div>
  </div>
</template>

<script>
import EventDescription from '@/components/base/eventSpecification/EventDescription'
import EventTime from '@/components/base/eventSpecification/EventTime.vue'
import EventDate from '@/components/base/eventSpecification/EventDate.vue'
import StyleWrapper from '@/components/FTE/StyleWrapper'
import Nav from '@/components/FTE/Nav'

import { mapGetters } from 'vuex'

const stepSequence = [
  'description', 'time', 'date'
]
export default {
  name: 'NewEvent',
  components: { EventDescription, StyleWrapper, Nav, EventTime, EventDate },
  data () {
    return {
      stepIndex: 0,
      event: {
        time: { err: null },
        date: { err: null },
        description: { err: null }
      }
    }
  },
  computed: {
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
    ...mapGetters([ 'currentUser' ])
  },
  methods: {
    submitEvent () {
      // TODO
    },
    nextStep () {
      if (this.currentIndex === stepSequence.length - 1) {
        this.submitEvent()
      } else {
        this.$router.push({ name: 'NewEvent', params: { step: stepSequence[this.currentIndex + 1] } })
      }
    },
    prevStep () {
      if (this.currentIndex > 0) {
        this.$router.push({ name: 'NewEvent', params: { step: stepSequence[this.currentIndex - 1] } })
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
  padding-top: 50px;
  padding-bottom: 50px;
  background-color: #1c8be7;
}
</style>
