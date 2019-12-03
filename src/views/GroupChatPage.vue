<template>
  <div>
    <MainNav />
    <div class="chats__container w-container">
      <div class="chat">
        <div class="chat-max-width-container">
          <div class="chat-detail--header">
            <div class="chat-header--images">
              <div class="chat-neg-marg-group"
                   v-if="parents"
              >
                <div class="parent-going"
                     v-for="parent in displayParents">
                  <AvatarImage
                    :imageSize="32"
                    :person="parent"
                    class="image-8" />
                </div>
              </div>
            </div>
            <div class="div-block-14">
              <h1 class="chat-heading-text">Ideas for today and tomorrow</h1>
            </div>
          </div>
          <div v-if="!comments || comments.length === 0"
               class="chat-content--wrapper">
            <ConversationDivider
              dividerText="No ideas yet, add yours!" />
          </div>
          <div v-if="comments"
               class="chat-content--wrapper">
            <ConversationDay
              v-for="(ca) in conversationDays"
              :key="ca.day"
              :day="ca.day"
              :messages="ca.messages"
            />
            <div v-if="postPending">
              <LoadingSpinner
                size="40px"
                marginTop="30px"
              />
            </div>

          </div>
        </div>
      </div>
      <div id="page-bottom" />
      <MessageSendBox
        @message-submitted="sendMessage"
        v-model="newMessage"
        :class="{accomodateRoundedCorners: accomodateRoundedCorners }"
        :openKeyboard="openKeyboard"
      />
    </div>
  </div>
</template>

<script>
import moment from 'moment'
import { mapGetters } from 'vuex'

import VueScrollTo from 'vue-scrollto'
import MainNav from '@/components/MainNav'
import MessageSendBox from '@/components/MessageSendBox'
import AvatarImage from '@/components/base/AvatarImage'
import ConversationDay from '@/components/ConversationDay'
import LoadingSpinner from '@/components/LoadingSpinner'
import ConversationDivider from '@/components/ConversationDivider.vue'
import { postComment, fetchGroupMembers, fetchComments } from '@/utils/api'
import { redirect, platform, alerts } from '@/mixins'

export default {
  name: 'GroupChatPage',
  data () {
    return {
      postPending: false,
      newMessage: null,
      comments: null,
      parents: null
    }
  },
  props: {
    groupId: { required: true },
    openKeyboard: { default: false }
  },
  components: { MainNav, MessageSendBox, AvatarImage, ConversationDay, LoadingSpinner, ConversationDivider },
  mixins: [ platform, redirect, alerts ],
  methods: {
    scrollOnNextTick () {
      this.$nextTick(() => {
        VueScrollTo.scrollTo('#page-bottom', { duration: 500, easing: 'ease-in' })
      })
    },
    async update () {
      this.comments = await fetchComments(this.groupId)
    },
    async sendMessage () {
      if (this.postPending || !this.newMessage) { return }
      this.postPending = true
      const pendingMessage = this.newMessage
      this.newMessage = null
      try {
        await postComment(this.groupId, pendingMessage)
        this.scrollOnNextTick()
      } catch (e) {
        this.newMessage = pendingMessage
      } finally {
        await this.update()
        this.postPending = false
      }
    }
  },
  computed: {
    displayParents () {
      return this.parents.slice(0, 4).concat([this.currentUser])
    },
    conversationDays () {
      if (!this.comments) { return [] }
      const dayGroups = this.comments.reduce(function (days, comment) {
        const dayKey = moment(comment.createdAt).format('YYYY-MM-DD')
        days[dayKey] = days[dayKey] || []
        days[dayKey].push(comment)
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
    if (this.redirectToSignupIfNotAuthenticated()) { return }
    try {
      this.parents = await fetchGroupMembers(this.groupId)
      await this.update()
      this.scrollOnNextTick()
    } catch (e) {
      this.showAlertOnNextRoute('Sorry, you don\'t have access to that page', 'failure')
      this.$router.push({ name: 'Parents' })
      this.logError(e)
    }
    this.pollingInterval = setInterval(this.update, 30000)
  },
  destroyed () {
    clearInterval(this.pollingInterval)
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
