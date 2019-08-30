import { mapGetters } from 'vuex'

export default {
  methods: {
    /*
    * returns true if redirected
    */
    redirectToSignupIfNotAuthenticated: function (callbackRoute) {
      if (!this.isAuthenticated) {
        this.log('redirecting to log-in')
        if (callbackRoute) {
          this.setRedirectRoute(callbackRoute)
        } else {
          this.setRedirectRouteHere()
        }
        this.$router.push({ name: 'SignIn' })
        return true
      }
      return false
    },
    setRedirectRoute: function (route) {
      this.$store.commit('setRedirectRoute', { route })
    },
    setRedirectRouteHere: function () {
      this.setRedirectRoute({
        name: this.$route.name,
        params: this.$route.params
      })
    },
    redirectOrProceed () {
      if (this.currentUser.hasAllRequiredFields) {
        if (this.redirectRoute) {
          this.$router.push(this.redirectRoute)
          this.$store.commit('resetRedirectRoute')
        } else {
          this.$router.push({ name: 'Search' })
        }
      } else if (this.currentUser.id) {
        this.$router.push({ name: 'Onboarding' })
      } else {
        throw Error('current user has no id')
      }
    }
  },
  computed: mapGetters(['isAuthenticated', 'currentUser'])
}
