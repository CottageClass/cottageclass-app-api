export default {
  methods: {
    showAlert (message, status) {
      const store = this.$store
      store.commit('showAlert',
        {
          alert: { message, status }
        })
    },
    showBriefAllert (message, status) {
      const store = this.$store
      store.commit('showAlert',
        {
          alert: { message, status }
        })
      setTimeout(function () {
        store.commit('hideAlert')
      }, 5000)
    },
    showAlertOnNextRoute (message, status) {
      this.$store.commit(
        'showAlertOnNextRoute',
        { alert: { message, status } }
      )
    }
  }
}
