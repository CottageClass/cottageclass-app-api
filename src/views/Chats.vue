<template>
  <div>
    <MainNav />
    <LoadingSpinner v-if="!chats" />
    <div v-else class="chat">
      <div class="chat-max-width-container">
        <div class="chat-detail--header">
          <h1 class="chats-heading-text">Chats</h1>
        </div>
        <div v-if="chats"
             class="chat-content--wrapper">
          <ConversationThumb v-for="conversation in chats"
                             :conversation="conversation"
                             :key="`chat-teaser-${conversation.partner.id}`"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

import ConversationThumb from '@/components/ConversationThumb'
import MainNav from '@/components/MainNav'
import LoadingSpinner from '@/components/LoadingSpinner'
import { redirect } from '@/mixins'

import { fetchConversations, fetchComments } from '@/utils/api'

export default {
  name: 'Chats',
  data () {
    return {
      chats: null
    }
  },
  components: { MainNav, ConversationThumb, LoadingSpinner },
  mixins: [ redirect ],
  computed: {
    ...mapGetters(['currentUser'])
  },
  methods: {
    async fetchChats () {
      this.chats = await fetchConversations(this.currentUser.id)
      for (let groupId of this.currentUser.groups) {
        const groupComments = await fetchComments(groupId)
        if (groupComments && groupComments.length > 0) {
          const lastComment = groupComments[0]
          const mockChat = {
            groupId,
            partner: {
              ...lastComment.sender,
              groupName: 'Ideas for today and tomorrow'
            },
            message: {
              content: lastComment.content,
              createdAt: lastComment.createdAt
            }
          }
          this.chats.push(mockChat)
        }
      }
      this.chats.sort((a, b) => {
        const date1 = new Date(a.message.createdAt)
        const date2 = new Date(b.message.createdAt)
        return date2 - date1
      })
    },
    async poll () {
      await this.fetchChats()
    }
  },
  destroyed () {
    clearInterval(this.pollingInterval)
  },
  async created () {
    if (this.redirectToSignupIfNotAuthenticated()) { return }
    await this.fetchChats()
    this.pollingInterval = setInterval(this.poll, 30000)
  }
}
</script>

<style scoped lang="scss">
.chat {
  position: relative;
  display: flex;
  width: 100%;
  min-height: 100vh;
  flex-direction: column;
  align-items: center;
  background-color: #fff;
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

.chat-content--wrapper {
  width: 100%;
  margin-top: 0;
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

.chats-heading-text {
  margin-top: 0;
  margin-bottom: 0;
  margin-left: 0;
  font-size: 16px;
  line-height: 24px;
}

@media (max-width: 991px){
  .chat-detail--header {
    margin-top: 0;
  }

}
</style>
