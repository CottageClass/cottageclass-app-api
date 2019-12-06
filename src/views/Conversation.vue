<template>
  <div class="page-wrapper">
    <MainNav />
    <div class="chats__container w-container">
      <div class="chat">
        <div class="chat-max-width-container">
          <div class="chat-detail--header">
            <div class="chat-header--images">
              <div class="chat-neg-marg-group">
                <div class="chat-header--image">
                  <AvatarImage
                    :imageSize="32"
                    :person="currentUser"
                    class="image-8" />
                </div>
                <div class="parent-going"
                     @click="goToPartnerPage"
                >
                  <AvatarImage
                    :imageSize="32"
                    :person="partner"
                    class="image-8" />
                </div>
              </div>
            </div>
            <div class="div-block-14">
              <h1 class="chat-heading-text">{{titleText}}</h1>
            </div>
          </div>
          <div v-if="!messages || messages.length === 0"
               class="chat-content--wrapper">
            <ConversationDivider
              :dividerText="chatStartedText" />
          </div>
          <div v-if="partner && messages"
               class="chat-content--wrapper">
            <ConversationDay
              v-for="(ca) in conversationDays"
              :key="ca.day"
              :day="ca.day"
              :messages="ca.messages"
              :partner="partner"
            />
            <Message v-if="tempMessage"
                     :message="tempMessage"
                     :partner="partner"/>
          </div>
        </div>
      </div>
      <MessageSendBox
        @message-submitted="sendMessage"
        v-model="newMessage"
        :class="{accomodateRoundedCorners: accomodateRoundedCorners }"
      />
    </div>
    <div id="page-bottom"> </div>
  </div>
</template>

<script>
import VueScrollTo from 'vue-scrollto'
import { mapGetters } from 'vuex'
import moment from 'moment'

import MainNav from '@/components/MainNav'
import ConversationDay from '@/components/ConversationDay'
import ConversationDivider from '@/components/ConversationDivider.vue'
import AvatarImage from '@/components/base/AvatarImage'
import MessageSendBox from '@/components/MessageSendBox'
import Message from '@/components/Message'

import { platform, alerts } from '@/mixins'
import { fetchMessages, fetchUser, submitMessage } from '@/utils/api'

export default {
  name: 'Conversation',
  components: { ConversationDay, AvatarImage, MainNav, MessageSendBox, ConversationDivider, Message },
  mixins: [ platform, alerts ],
  data () {
    return {
      newMessage: null,
      messages: null,
      partner: null,
      tempMessage: null,
      messagePending: false
    }
  },
  props: {
    userId: { required: true }
  },
  methods: {
    goToPartnerPage () {
      this.$router.push({ name: 'UserPage', params: { id: this.partner.id } })
    },
    scrollOnNextTick () {
      this.$nextTick(() => {
        VueScrollTo.scrollTo('#page-bottom', { duration: 500, easing: 'ease-in' })
      })
    },
    async poll () {
      this.messages = await fetchMessages(this.userId)
      this.removeTempMessage()
    },
    async showTempMessage (userId, content) {
      this.tempMessage = {
        content: content,
        createdAt: 'Just Now',
        receiverId: userId,
        senderId: this.currentUser.id
      }
    },
    removeTempMessage () {
      this.tempMessage = null
    },
    async sendMessage () {
      if (this.messagePending || !this.newMessage) { return }
      this.messagePending = true
      const pendingMessage = this.newMessage
      this.newMessage = null
      await this.showTempMessage(this.partner.id, pendingMessage)
      try {
        this.scrollOnNextTick()
        await submitMessage(this.partner.id, pendingMessage)
      } catch (e) {
        this.logError(e)
        this.showAlert('There was an error submitting your chat.  Try again later', 'failure')
        this.newMessage = pendingMessage
      } finally {
        await this.update()
        this.messagePending = false
      }
    },
    async update () {
      try {
        this.messages = await fetchMessages(this.userId)
      } catch (e) {
        this.logError(e)
      } finally {
        this.removeTempMessage()
      }
    }
  },
  computed: {
    titleText () {
      if (this.partner) {
        return 'Chat with ' + this.partnerName
      } else {
        return 'loading'
      }
    },
    chatStartedText () {
      return 'You just started a new chat. Say hi!'
    },
    partnerName () {
      return this.partner.firstName + ' ' + this.partner.lastInitial + '.'
    },
    conversationDays () {
      if (!this.messages) { return [] }
      const dayGroups = this.messages.reduce(function (days, message) {
        const dayKey = moment(message.createdAt).format('YYYY-MM-DD')
        days[dayKey] = days[dayKey] || []
        days[dayKey].push(message)
        return days
      }, {})
      const ordereddays = Object.keys(dayGroups).sort()
      return ordereddays.map((day) => {
        return { day, messages: dayGroups[day] }
      })
    },
    ...mapGetters(['currentUser'])
  },
  async created () {
    this.poll()
    this.pollingInterval = setInterval(this.poll, 30000)
    this.partner = await fetchUser(this.userId)
    this.scrollOnNextTick()
  },
  destroyed () {
    clearInterval(this.pollingInterval)
  }
}
</script>

<style scoped lang="scss">
.parent-going {
  cursor: pointer;
  display: flex;
  overflow: hidden;
  width: 36px;
  height: 36px;
  min-height: 36px;
  min-width: 36px;
  margin-left: -12px;
  justify-content: center;
  align-items: center;
  border-style: solid;
  border-width: 2px;
  border-color: #fff;
  border-radius: 50%;
}
.accomodateRoundedCorners {
  padding-bottom: 20px;
}

.image-8 {
  width: 32px;
  height: 32px;
  min-height: 32px;
  min-width: 32px;
}

.chats__container {
  position: relative;
  display: flex;
  flex-direction: column;
  padding: 32px;
  align-items: flex-start;
  width: 100%;
  flex: 1;
}
.page-wrapper {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
.chat {
  position: relative;
  display: flex;
  width: 100%;
  flex-direction: column;
  align-items: center;
  background-color: #fff;
  flex: 1;
}

.chat-detail--header {
  position: sticky;
  top: 0;
  z-index: 500;
  display: flex;
  width: 100%;
  margin-top: 32px;
  padding: 12px 16px;
  align-items: center;
  background-color: #fff;
}

.chat-header--images {
  display: block;
}

.chat-header--image {
  display: flex;
  overflow: hidden;
  width: 36px;
  height: 36px;
  min-height: 36px;
  min-width: 36px;
  margin-left: -12px;
  justify-content: center;
  align-items: center;
  border-style: solid;
  border-width: 2px;
  border-color: #fff;
  border-radius: 50%;
}

.chat-heading-text {
  margin-top: 0;
  margin-bottom: 0;
  margin-left: 16px;
  font-size: 16px;
  line-height: 24px;
}

.chat-neg-marg-group {
  display: flex;
  margin-top: 0;
  margin-bottom: 0;
  padding-left: 12px;
}

.div-block-14 {
  display: flex;
  align-items: center;
}

.chat-content--wrapper {
  word-wrap: break-word;
  overflow-wrap: break-word;
  word-break: break-word;
  width: 100%;
  margin-top: 32px;
  padding-bottom: 100px;
}

.chat-max-width-container {
  display: flex;
  max-width: 800px;
  width: 100%;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

@media (max-width: 991px){
  .chats__container {
    margin-top: 24px;
    flex-direction: column-reverse;
  }

  .chat-detail--header {
    margin-top: 0;
  }

}

@media (max-width: 767px){
  .chats__container {
    position: static;
    margin-top: 0;
    padding-right: 0;
    padding-left: 0;
    flex-direction: column-reverse;
  }

}
</style>
