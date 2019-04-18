import { mapGetters } from 'vuex'

export default {
  methods: {
    /*
    * returns true if redirected
    */
    redirectToSignupIfNotAuthenticated: function () {
      if (!this.isAuthenticated) {
        this.log('redirecting to sing-up')
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
    }
  },
  computed: mapGetters(['isAuthenticated'])
}
