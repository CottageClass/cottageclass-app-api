import { trackEvent } from '@/utils/ahoy'
import validationError from '@/mixins/validationError'

export default {
  mixins: [ validationError ],
  computed: {
    validationError () {
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
    },
    nextStep () {

    },
    prevStep () {
      if (this.stepIndex > 0) {
        this.$router.replace({ params: { stepName: this.stepSequence[this.stepIndex - 1] } })
        window.scrollTo(0, 0)
      } else {
        this.$router.go(-1)
      }
    }
  },
  watch: {
    nextButtonState: {
      handler: () => {
        this.$emit('set-nav-props', {
          button: this.nextButtonState
        })
      },
      immediate: true
    }

  },
  created () {
    this.$emit('set-nav-props', {
      nextButtonHandler: this.nextStep,
      prevButtonHandler: this.prevStep
    })
    if (!this.stepName || this.stepIndex === -1) {
      this.$router.replace({ params: { stepName: this.stepSequence[0] } })
    }
  }
}
