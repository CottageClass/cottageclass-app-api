<template>
  <div class="item-container">
    <div class="avatar-container">
      <AvatarImage
        :person="user"
        className="avatar"/>
    </div>
    <div class="info-container">
      <div class="heading">
        <span class="name">{{ user.firstName }}</span>
        <span class="children" v-if="user.childAges && user.childAges.length">
          {{childAgeString}}
        </span>
      </div>
      <div class="details">
        <span class="distance">{{distanceFromMapCenter(user.location) + 'mi'}}</span>
        <span class="profession" v-if="user.childAges && user.childAges.length">
          {{profession}}
        </span>
      </div>
    </div>
    <div class="meet-button w-button"
         :class="meetStatus"
         @click="meetButtonClick">
      {{meetButtonText}}
      <img v-if="meetStatus==='sent'"
           src="@/assets/check-green.svg"
           alt=""
           class="checkmark-image">
    </div>
  </div>
</template>

<script>
import AvatarImage from '@/components/base/AvatarImage.vue'

import { distanceHaversine, initProxySession } from '@/utils/api'
import { mapGetters } from 'vuex'
import _ from 'lodash'
import { setTimeout, clearTimeout } from 'timers'
import { alerts } from '@/mixins'

export default {
  name: 'UserListItem',
  data () {
    return {
      isSelected: false,
      inviteComplete: false,
      meetStatus: 'none',
      sendingTimeout: null
    }
  },
  props: ['user', 'mapCenter'],
  components: { AvatarImage },
  mixins: [alerts],
  methods: {
    meetButtonClick () {
      switch (this.meetStatus) {
        case 'none':
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
        await initProxySession(this.currentUser.id, this.user.id, this.meetMessages[0], this.acknowledgeMessage)
        await initProxySession(this.currentUser.id, this.user.id, this.meetMessages[1])
        this.meetStatus = 'sent'
      } catch (e) {
        this.meetStatus = 'meet'
        this.showBriefAllert('There was a problem sending your message.  Please try again later', 'failure')
      }
    }
  },
  computed: {
    meetButtonText () {
      switch (this.meetStatus) {
        case 'none':
          return 'Meet'
        case 'sending':
          return 'Undo'
        case 'sent':
          return 'Sent'
        default:
          return 'Meet'
      }
    },
    meetMessages () {
      return [
        `Hi ${this.user.firstName}, I'm a parent in ${this.currentUser.locality} and I'd love to meet up for a playdate. When might be a good time? -${this.currentUser.firstName}`,
        `(${this.currentUser.firstName} has ${this.messageChildAgeString}, lives ${this.distanceFromCurrentUser()} miles from you, and their profile is here: https://kidsclub.io/user/${this.currentUser.id}. Good luck & enjoy! ❤️ KidsClub.io)`
      ]
    },
    acknowledgeMessage () {
      return `We just texted ${this.user.firstName} to ask them when a good time for a playdate would be. You can send ${this.user.firstName} any additional information or questions by texting this number. ❤️ KidsClub.io`
    },
    messageChildAgeString () {
      const ages = this.user.childAges
      if (ages.length === 1) {
        return '1 kid age ' + ages[0]
      } else {
        return ages.length + ' kids ages ' + _.join(_.slice(ages, 0, ages.length - 1), ', ') + ' & ' + _.last(ages)
      }
    },
    childAgeString () {
      const ages = this.user.childAges
      return ages.length + ' kid' + (ages.length > 1 ? 's' : '') + ' (' + ages.join(', ') + ')'
    },
    distanceFromCurrentUser () {
      if (this.currentUser) {
        const location = this.currentUser.location
        return function () {
          return distanceHaversine(location.lat, location.lng, this.mapCenter.lat, this.mapCenter.lng)
        }
      } else {
        return ''
      }
    },
    distanceFromMapCenter () {
      return function (location) {
        return distanceHaversine(location.lat, location.lng, this.mapCenter.lat, this.mapCenter.lng)
      }
    },
    profession () {
      const list = []
      if (this.user.jobPosition) {
        list.push(_.capitalize(this.user.jobPosition))
      }
      if (this.user.employer) {
        list.push(_.capitalize(this.user.employer))
      }
      return list.join(', ')
    },
    ...mapGetters([ 'currentUser' ])
  }
}
</script>

<style lang="scss" scoped>
.avatar-container {
  min-width: 80px;
  height: 80px;
}
.avatar {
  height: 80px;
  min-width: 80px;
  max-width: 80px;
  margin: 0px 1px 1px 0px;
  border-radius: 50%;
}
.item-container {
  display: flex;
  width: 100%;
  margin-top: 0px;
  padding: 20px;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, .08);
}
.name {
  font-size: 16px;
  line-height: 20.8px;
  font-weight: 700;
}
.children {
  margin-bottom: -1px;
  margin-left: 8px;
  color: rgba(0, 0, 0, .6);
  font-size: 11px;
  line-height: 20.8px;
  font-weight: 400;
}
.details {
  color: rgba(0, 0, 0, .6);
  font-size: 11px;
  line-height: 20.8px;
  font-weight: 400;
}

.distance {
  font-weight: bold;
}
.info-container {
  margin-right: 16px;
  margin-left: 16px;
  flex-direction: column;
}
.meet-button {
  text-align: center;
  min-width: 80px;
  border: 1px solid #1f88e9;
  border-radius: 4px;
  background-color: transparent;
  color: #1f88e9;
  font-size: 13px;

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

@media (max-width: 767px){
  .avatar, .avatar-container {
    max-height: 60px;
    max-width: 60px;
    min-height: 60px;
    min-width: 60px;
  }
}

</style>
