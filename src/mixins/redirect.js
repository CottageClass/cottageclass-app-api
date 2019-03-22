export default {
  methods: {
    setRedirectRouteHere: function () {
      this.$store.commit('setRedirectRoute', {
        route: {
          name: this.$route.name,
          params: this.$route.params
        }
      })
    }
  }
}
