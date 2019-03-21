export default {
  methods: {
    setRedirectRouteHere: function () {
      this.$store.commit('setRedirectRoute', {
        route: {
          name: 'RsvpConfirmation',
          params: { eventId: this.eventId }
        }
      })
    }
  }
}
