import _ from 'lodash'
import { mapGetters } from 'vuex'

export default {
  methods: {
    // accepts a callback that take `window` as an argument where window is the popup window
    authenticate: function (provider, callback) {
      const authUri = `${window.location.origin}/users/auth/facebook`
      _.assign(window, { oauthCallback: callback })
      // TODO remove this callback after it's called
      this.createPopup(
        authUri,
        580,
        400,
        provider)
    },

    createPopup: function (url, width, height, name) {
      var left = (screen.width/2)-(width/2);
      var top = (screen.height/2)-(height/2);
      return window.open(
        url,
        name,
        "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top
      )
    },
    authenticateFacebook: function () {
      const component = this
      this.authenticate('facebook', function (data) {
        if (data.err) {
          // TODO handle this error with an alert
          console.log('error in authentication : ', data.err)
          component.$router.push({ name: 'Home' })
        } else {
          // determine where the user should go next
          console.log('Facebook authentication successful')
          component.$store.dispatch('establishUser', { JWT: data.token })
          if (component.currentUser.hasAllRequiredFields) {
            if (component.redirectPath) {
              component.$router.push(component.redirectPath)
              component.$store.commit('resetRedirectPath')
            } else {
              component.$router.push({ name: 'Home' })
            }
          } else {
            component.$router.push({ name: 'OnboardNewUser' })
          }
        }
      })
    },
  },
  computed: mapGetters(['currentUser', 'redirectPath'])
}
