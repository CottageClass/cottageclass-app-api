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
  created () {
    if (!this.stepName || this.stepIndex === -1) {
      this.$router.replace({ params: { stepName: this.stepSequence[0] } })
    }
  }
}
