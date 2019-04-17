import { mapGetters } from 'vuex'

export default {
  methods: {
    redirectToSignupIfNotAuthenticated: function (msg) {
      if (!this.isAuthenticated) {
        this.log(msg)
        this.setRedirectRouteHere()
        this.$router.push({ name: 'SignUp' })
      }
    },
    setRedirectRouteHere: function () {
      this.$store.commit('setRedirectRoute', {
        route: {
          name: this.$route.name,
          params: this.$route.params
        }
      })
    }
  },
  computed: mapGetters(['isAuthenticated'])
}
