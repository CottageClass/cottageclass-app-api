import { redirect } from '@/mixins'
import { mapGetters } from 'vuex'

export default {
  mixins: [ redirect ],
  methods: {
    // accepts a callback that take `window` as an argument where window is the popup window
    authenticate: function (provider, callback) {
      const authUri = `${window.location.origin}/users/auth/facebook`
      Object.assign(window, { oauthCallback: callback })
      this.createPopup(
        authUri,
        580,
        400,
        provider)
    },

    createPopup: function (url, width, height, name) {
      var left = (screen.width / 2) - (width / 2)
      var top = (screen.height / 2) - (height / 2)
      return window.open(
        url,
        name,
        'menubar=no,toolbar=no,status=no,width=' + width + ',height=' + height + ',toolbar=no,left=' + left + ',top=' + top
      )
    },
    authenticateFacebook: function () {
      const component = this
      this.authenticate('facebook', function (data) {
        if (data.err) {
          // TODO handle this error with an alert
          console.log('error in authentication : ', data.err)
          component.$router.push({ name: 'Events' })
        } else {
          // determine where the user should go next
          console.log('Facebook authentication successful')
          component.$store.dispatch('establishUser', { JWT: data.token })
          component.redirectOrProceed()
        }
      })
    }
  },
  computed: mapGetters(['currentUser', 'redirectRoute'])
}
