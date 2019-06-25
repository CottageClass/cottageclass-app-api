<template>
  <div :class="'w-button '+meetStatus"
        @click="meetButtonClick">
    {{meetButtonText}}
  </div>
</template>

<script>
import { setTimeout, clearTimeout } from 'timers'
import { initProxySession } from '@/utils/api'
import { mapGetters } from 'vuex'
import { alerts, redirect, messaging } from '@/mixins'

export default {
  name: 'MeetButton',
  props: ['targetUser', 'fillStyle', 'layoutStyle', 'defaultText', 'shouldShowDescriptionModal', 'allowUndo'],
  mixins: [alerts, redirect, messaging],
  data () {
    return {
      meetStatus: 'none'
    }
  },
  methods: {
    meetButtonClick (event) {
      this.$emit('meetButtonClick', { event })
      switch (this.meetStatus) {
        case 'none':
          this.showDescriptionModal()
          break
        case 'sending':
          this.undoMessageSending()
          break
      }
    },
    showDescriptionModal () {
      if (this.shouldShowDescriptionModal) {
        this.$store.commit('showModal', {
          modal: {
            title: `We've sent ${this.targetUser.firstName} your request to meet!`,
            bodyText: this.targetUser.firstName + ' will reply if interested. When they do, all you have to do is:<br/>' +
            '1. Decide on a time to meet<br/>' +
            '2. Decide on a place to meet (we recommend meeting in one of your homes)<br/>' +
            '3. Decide on an activity (This is optional. Sometimes it’s best to just meet and talk!)<br/>',
            buttonNames: ['OK'],
            closeCallback: this.checkAuthenticationAndInitiateMessageSending.bind(this)
          }
        })
        if (this.$route.name === 'Events') {
          this.$store.commit('setHasShowEventsPageMessagingDescription')
        }
      } else {
        this.checkAuthenticationAndInitiateMessageSending()
      }
    },
    checkAuthenticationAndInitiateMessageSending () {
      if (this.redirectToSignupIfNotAuthenticated()) {
        this.$store.commit('addPendingWave', { targetUser: this.targetUser })
      } else {
        if (this.allowUndo) {
          this.initiateMessageSending()
        } else {
          this.sendMessage()
        }
      }
    },
    undoMessageSending () {
      clearTimeout(this.sendingTimeout)
      this.meetStatus = 'none'
    },
    initiateMessageSending: async function () {
      const that = this
      that.meetStatus = 'sending'
      that.sendingTimeout = setTimeout(function () {
        that.sendMessage()
      }, 4000)
    },
    sendMessage: async function () {
      try {
        await initProxySession(this.currentUser.id,
          this.targetUser.id,
          this.meetMessage(this.targetUser),
          this.acknowledgeMessage(this.targetUser))
        this.meetStatus = 'sent'
        this.$store.commit('addSentWave', { targetUserId: this.targetUser.id })
      } catch (e) {
        console.error(e)
        this.meetStatus = 'none'
        this.showBriefAllert('There was a problem sending your message.  Please try again later', 'failure')
      }
    }
  },
  computed: {
    meetButtonText () {
      switch (this.meetStatus) {
        case 'none':
          return this.defaultText
        case 'sending':
          return 'Undo'
        case 'sent':
          return 'Sent'
        default:
          return ''
      }
    },
    ...mapGetters([ 'currentUser', 'waveHasBeenSent' ])
  },
  created () {
    if (this.waveHasBeenSent(this.targetUser.id)) {
      this.meetStatus = 'sent'
    }
  }
}
</script>
