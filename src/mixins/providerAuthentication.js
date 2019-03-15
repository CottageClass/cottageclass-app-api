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
          component.$store.dispatch('establishUser', { JWT: data.token })
          console.log(component.currentUser.hasAllRequiredFields)
          if (component.currentUser.hasAllRequiredFields) {
            component.$router.push(component.redirectPath)
            component.$store.commit('resetRedirectPath')
          } else {
            component.$router.push({ name: 'OnboardNewUser' })
          }
        }
      })
    },
  },
  computed: mapGetters(['currentUser', 'rsvpAttemptedId', 'redirectPath'])
}

    //   let component = this
    //   this.$auth.authenticate(provider)
    //     .then(res => {
    //       console.log('auth SUCCESS')
    //       return this.$store.dispatch('establishCurrentUserAsync', this.currentUser.id)
    //     }).then(() => {
    //       console.log(this.currentUser)
    //       if (this.currentUser.hasAllRequiredFields && !this.rsvpAttemptedId) {
    //         // redirect to home screen if they haven't attempted an RSVP
    //         this.$router.push({ name: 'Home' })
    //       } else if (this.currentUser.hasAllRequiredFields && !!this.rsvpAttemptedId) {
    //         // confirm that they want to RSVP if they have attempted an RSVP
    //         this.$router.push({ name: 'RsvpConfirmation', params: { eventId: this.rsvpAttemptedId } })
    //       } else if (this.currentUser.id) {
    //         // begin onboarding
    //         this.$router.push({ name: 'OnboardNewUser' })
    //       } else {
    //         return false
    //       }
    //     }).catch(function (err) {
    //       console.log('auth FAILURE or user not onboarded yet')
    //       console.log(err)
    //     })
    // }

