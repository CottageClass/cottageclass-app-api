<template>
  <div class="meet-button"
        :class="meetStatus + ' ' + fillStyle + ' ' + layoutStyle + (layoutStyle==='fat' ? ' w-button' : '')"
        @click="meetButtonClick">
    {{meetButtonText}}
    <img v-if="meetStatus==='sent'"
          src="@/assets/check-green.svg"
          alt=""
          class="checkmark-image">
  </div>
</template>

<script>
import { setTimeout, clearTimeout } from 'timers'
import { initProxySession } from '@/utils/api'
import { mapGetters } from 'vuex'
import { alerts, redirect, messaging } from '@/mixins'

export default {
  name: 'MeetButton',
  props: ['targetUser', 'fillStyle', 'layoutStyle'],
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
            bodyText: this.targetUser.firstName + ' will reply if interested. When she does, all you have to do is:<br/>' +
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
        this.initiateMessageSending()
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
    shouldShowDescriptionModal () {
      if (this.$route.name === 'ProviderProfile') {
        return true
      }
      if (this.$route.name === 'Events' && !this.hasShowEventsPageMessagingDescription) {
        return true
      }
      return false
    },
    meetButtonText () {
      switch (this.meetStatus) {
        case 'none':
          return (this.fillStyle === 'outline') ? 'Wave' : 'Invite for a playdate'
        case 'sending':
          return 'Undo'
        case 'sent':
          return 'Sent'
        default:
          return 'Wave'
      }
    },
    ...mapGetters([ 'currentUser', 'waveHasBeenSent', 'hasShowEventsPageMessagingDescription' ])
  },
  created () {
    if (this.waveHasBeenSent(this.targetUser.id)) {
      this.meetStatus = 'sent'
    }
  }
}
</script>

<style scoped lang="scss">

.meet-button.solid {
  color: white;
  background-color: #1f88e9;

  &.none:hover {
    background-image: linear-gradient(180deg, rgba(0, 0, 0, .02), rgba(0, 0, 0, .04));
  }
  &.sending {
    color: rgb(212, 80, 18);
    border: 1px rgb(212, 80, 18) solid;
    background-color: transparent;
    &:hover {
      background-image: linear-gradient(180deg, rgba(255, 0, 0, .1), rgba(255, 0, 0, .04));
    }
  }
  &.sent {
    color:  rgb(12, 186, 82);
    border-color:  rgb(12, 186, 82);
    background-color:  rgba(12, 186, 82, .2);
    border-width: 2px;
    cursor: default;
  }

}

.meet-button.outline {
  border: 1px solid #1f88e9;
  background-color: transparent;
  color: #1f88e9;
  -webkit-text-fill-color: #1f88e9;  // DO NOT REMOVE.  REQUIRED FOR SAFARI

  &.none:hover {
    background-image: linear-gradient(180deg, rgba(0, 0, 0, .02), rgba(0, 0, 0, .04));
  }
  &.sending {
    color: rgb(212, 80, 18);
    -webkit-text-fill-color: rgb(212, 80, 18);  // DO NOT REMOVE.  REQUIRED FOR SAFARI
    border-color:  rgb(212, 80, 18);

    &:hover {
      background-image: linear-gradient(180deg, rgba(255, 0, 0, .1), rgba(255, 0, 0, .04));
    }
  }
  &.sent {
    color:  rgb(12, 186, 82);
    -webkit-text-fill-color: rgb(12, 186, 82);  // DO NOT REMOVE.  REQUIRED FOR SAFARI
    border-color:  rgb(12, 186, 82);
    background-color:  rgba(12, 186, 82, .2);
    border-width: 2px;
    cursor: default;
  }
}

.meet-button {
  text-align: center;
  border-radius: 4px;
  font-size: 13px;
  &.sent {
    cursor: default;
  }
}
.meet-button.slim {
  display: flex;
  width: 100%;
  margin-bottom: 0px;
  padding: 6px 10px;
  justify-content: center;
  align-items: center;
  font-size: 12px;
  line-height: 15px;
  text-align: center;
}
.meet-button.fat {
    min-width: 80px;
}
</style>
