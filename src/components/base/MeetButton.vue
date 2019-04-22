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
import { alerts, redirect } from '@/mixins'

export default {
  name: 'MeetButton',
  props: ['targetUser', 'fillStyle', 'layoutStyle'],
  mixins: [alerts, redirect],
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
          if (this.redirectToSignupIfNotAuthenticated()) { return }
          this.initiateMessageSending()
          break
        case 'sending':
          this.undoMessageSending()
          break
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
        await initProxySession(this.currentUser.id, this.targetUser.id, this.meetMessages[0], this.acknowledgeMessage)
        await initProxySession(this.currentUser.id, this.targetUser.id, this.meetMessages[1])
        this.meetStatus = 'sent'
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
          return (this.fillStyle === 'outline') ? 'Meet' : 'Invite for a playdate'
        case 'sending':
          return 'Undo'
        case 'sent':
          return 'Sent'
        default:
          return 'Meet'
      }
    },
    distanceBetweenUsers () {
      const targetLocation = this.targetUser.location
      return function () {
        return this.distanceFromCurrentUser(targetLocation.lat, targetLocation.lng)
      }
    },
    meetMessages () {
      let message1
      if (this.currentUser.locality) {
        message1 = `Hi ${this.targetUser.firstName}, I'm a parent in ${this.currentUser.locality} and I'd love to meet up for a playdate. When might be a good time? -${this.currentUser.firstName}`
      } else {
        message1 = `Hi ${this.targetUser.firstName}, I'm a parent near you and I'd love to meet up for a playdate. When might be a good time? -${this.currentUser.firstName}`
      }
      return [
        message1,
        `(${this.currentUser.firstName} has ${this.messageChildAgeString}, lives ${this.distanceBetweenUsers()} miles from you, and their profile is here: https://kidsclub.io/user/${this.currentUser.id}. Good luck & enjoy! ❤️ KidsClub.io)`
      ]
    },
    acknowledgeMessage () {
      return `We just texted ${this.targetUser.firstName} to ask them when a good time for a playdate would be. You can send ${this.targetUser.firstName} any additional information or questions by texting this number. ❤️ KidsClub.io`
    },
    messageChildAgeString () {
      const ages = this.targetUser.childAges
      if (ages.length === 1) {
        return '1 kid age ' + ages[0]
      } else {
        return ages.length + ' kids ages ' + ages.slice(0, ages.length - 1).join(', ') + ' & ' + ages[ages.length - 1]
      }
    },
    ...mapGetters([ 'currentUser', 'distanceFromCurrentUser' ])
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

  &.none:hover {
    background-image: linear-gradient(180deg, rgba(0, 0, 0, .02), rgba(0, 0, 0, .04));
  }
  &.sending {
    color: rgb(212, 80, 18);
    border-color:  rgb(212, 80, 18);

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
