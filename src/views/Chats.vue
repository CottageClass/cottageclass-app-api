<template>
  <div>
    <MainNav />
    <div class="chat">
      <div class="chat-max-width-container">
        <div class="chat-detail--header">
          <h1 class="chats-heading-text">Chats</h1>
        </div>
        <div v-if="conversations"
             class="chat-content--wrapper">
          <ConversationThumb v-for="conversation in conversations"
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
import { redirect } from '@/mixins'

import { fetchConversations } from '@/utils/api'

export default {
  name: 'Chats',
  data () {
    return {
      conversations: null
    }
  },
  components: { MainNav, ConversationThumb },
  mixins: [ redirect ],
  computed: {
    ...mapGetters(['currentUser'])
  },
  async created () {
    if (this.redirectToSignupIfNotAuthenticated()) { return }
    this.conversations = await fetchConversations(this.currentUser.id)
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
  width: 100%;
  display: flex;
  max-width: 800px;
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
