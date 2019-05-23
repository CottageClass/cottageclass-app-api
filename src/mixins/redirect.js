import { mapGetters } from 'vuex'

export default {
  methods: {
    /*
    * returns true if redirected
    */
    redirectToSignupIfNotAuthenticated: function () {
      if (!this.isAuthenticated) {
        this.log('redirecting to sign-up')
        this.setRedirectRouteHere()
        this.$router.push({ name: 'SignUp' })
        return true
      }
      return false
    },
    setRedirectRouteHere: function () {
      this.$store.commit('setRedirectRoute', {
        route: {
          name: this.$route.name,
          params: this.$route.params
        }
      })
    },
    redirectOrProceed () {
      if (this.currentUser.hasAllRequiredFields) {
        if (this.redirectRoute) {
          this.$router.push(this.redirectRoute)
          this.$store.commit('resetRedirectRoute')
        } else {
          this.$router.push({ name: 'Events' })
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
