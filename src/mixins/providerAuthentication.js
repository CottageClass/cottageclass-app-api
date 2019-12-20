import { redirect } from '@/mixins'
import { mapGetters } from 'vuex'
import { isIOSNativeApp } from '@/utils/platform'
import { postMessage } from '@/utils/iosAdapter'

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
      console.log('authenticating via facebook')
      const iosAuthentication = isIOSNativeApp()
      if (iosAuthentication) {
        try {
          const messageContents = {
            title: 'facebookLoginAttempt'
          }
          postMessage(messageContents) // post a message to ios to request push
        } catch (e) {
          this.logErro(e)
        }
      } else {
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
    }
  },
  computed: mapGetters(['currentUser', 'redirectRoute'])
}
