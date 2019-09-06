import { trackEvent } from '@/utils/ahoy'

export default {
  computed: {
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
    stepIndex () {
      return this.stepSequence.findIndex(s => s === this.stepName)
    }
  },
  methods: {
    trackStep (section) {
      this.$ga.event(this.context, 'stepComplete', this.stepName)
      trackEvent('step_complete', { context: this.context,
        step_name: this.stepName,
        section })
    }
  },
  created () {
    if (!this.stepName || this.stepIndex === -1) {
      this.$router.replace({ params: { stepName: this.stepSequence[0] } })
    }
  }
}
