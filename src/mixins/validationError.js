// assumes that the importing component has a computed property called `validationError`
// which returns null if there are no errors
export default {
  watch: {
    validationError: {
      handler () {
        this.$emit('set-nav-props', {
          errorMessage: this.validationError
        })
      },
      immediate: true
    }
  }
}
