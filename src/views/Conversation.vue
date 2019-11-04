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
                <div class="parent-going">
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
          <div class="chat-content--wrapper"
               v-if="partner && messages"
          >
            <ConversationMonth
              v-for="(cm) in conversationMonths"
              :key="cm.month"
              :month="cm.month"
              :messages="cm.messages"
              :partner="partner"
            />

          </div>
        </div>
      </div>
      <MessageSendBox
        @message-submitted="sendMessage"
        v-model="newMessage"
      />
      <div class="chat-input-wrapper">
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import moment from 'moment'

import MainNav from '@/components/MainNav'
import ConversationMonth from '@/components/ConversationMonth'
import AvatarImage from '@/components/base/AvatarImage'
import MessageSendBox from '@/components/MessageSendBox'

import { fetchMessages, fetchUser, submitMessage } from '@/utils/api'

export default {
  name: 'Conversation',
  components: { ConversationMonth, AvatarImage, MainNav, MessageSendBox },
  data () {
    return {
      newMessage: null,
      messages: null,
      partner: null
    }
  },
  props: {
    userId: { required: true }
  },
  methods: {
    async sendMessage (payload) {
      await submitMessage(this.partner.id, payload.message)
      this.messages = await fetchMessages(this.userId)
      this.newMessage = null
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
    partnerName () {
      return this.partner.firstName + ' ' + this.partner.lastInitial + '.'
    },
    conversationMonths () {
      if (!this.messages) { return [] }
      const monthGroups = this.messages.reduce(function (months, message) {
        const monthKey = moment(message.createdAt).format('YYYY-MM')
        months[monthKey] = months[monthKey] || []
        months[monthKey].push(message)
        return months
      }, {})
      const orderedMonths = Object.keys(monthGroups).sort().reverse()
      return orderedMonths.map((month) => {
        return { month, messages: monthGroups[month] }
      })
    },
    ...mapGetters(['currentUser'])
  },
  async created () {
    this.messages = await fetchMessages(this.userId)
    this.partner = await fetchUser(this.userId)
  }
}
</script>

<style scoped lang="scss">
.parent-going {
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
  width: 100%;
  margin-top: 32px;
  padding-bottom: 100px;
}

.chat-max-width-container {
  width: 100%;
  display: flex;
  max-width: 800px;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.chat-input-wrapper {
  position: fixed;
  left: 0%;
  top: auto;
  right: 0%;
  bottom: 0;
  display: flex;
  width: 100%;
  margin-bottom: 0;
  padding-right: 16px;
  padding-bottom: 0;
  padding-left: 16px;
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
