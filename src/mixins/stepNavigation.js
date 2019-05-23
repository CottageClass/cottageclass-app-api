export default {
  created () {
    if (!this.stepName) {
      this.$router.replace({ params: { stepName: this.stepSequence[0] } })
    }
  }
}
