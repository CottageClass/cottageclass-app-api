<template>
<a class="event-action-button"
   :class="meetStatus"
   @click.stop="meetButtonClick">
    <img v-if="icon" :src="icon" class="action-button-icon" />
    <div class="label-text">{{meetButtonText}}</div>
</a>
</template>

<script>
import { setTimeout, clearTimeout } from 'timers'
import { mapGetters } from 'vuex'
import { redirect, messaging, waves } from '@/mixins'

export default {
  name: 'MeetButton',
  props: {
    icon: {},
    targetUser: {},
    defaultText: {},
    shouldShowDescriptionModal: {},
    allowUndo: {}
  },
  mixins: [redirect, messaging, waves],
  data () {
    return {
      meetStatus: 'none'
    }
  },
  methods: {
    async initiateMessageSending () {
      const that = this
      that.meetStatus = 'sending'
      that.sendingTimeout = setTimeout(function () {
        that.sendMessage()
      }, 4000)
    },
    meetButtonClick (event) {
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
    undoMessageSending () {
      clearTimeout(this.sendingTimeout)
      this.meetStatus = 'none'
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
    storedSentWave () {
      return this.waveHasBeenSent(this.targetUser.id.toString())
    },
    ...mapGetters([ 'currentUser', 'waveHasBeenSent' ])
  },
  watch: {
    storedSentWave: {
      handler () {
        if (this.storedSentWave) {
          this.meetStatus = 'sent'
        } else {
          this.meetStatus = 'none'
        }
      },
      immediate: true
    }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.event-action-button {
  display: flex;
  padding: 8px 12px;
  justify-content: flex-start;
  align-items: center;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, 0.03);
  border-radius: 4px;
  background-color: #f3f3f3;
  display: flex;
  margin-top: 0;
  margin-right: 8px;
  margin-left: 0;
  align-items: flex-end;
  &:hover, &:active{
    background-color: rgba(0,0,0,0.06);
  }
  &.sent {
    cursor: default;
    & .label-text, .action-button-icon{
      opacity: 0.5;
    }
    &:hover, &:active{
      background-color: #f3f3f3;
    }
  }
}

.action-button-icon {
  width: 20px;
  height: 20px;
  margin-right: 6px;
  opacity: 1;
}

.label-text {
  color: #000;
  font-size: 13px;
}

@media (max-width: 991px){
  .event-action-button:hover {
    background-image: linear-gradient(180deg, transparent, transparent);
  }

  .event-action-button:active {
    background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.03), rgba(0, 0, 0, 0.03));
  }

}

@media (max-width: 767px){
  .label-text {
    font-size: 13px;
    line-height: 16px;
  }

}

@media (max-width: 479px){
  .event-action-button {
    width: 100%;
    width: 100%;
    margin-top: 0;
    margin-bottom: 8px;
  }
}
</style>
