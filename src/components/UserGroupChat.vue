<template>
  <div class="home-item">
    <div class="group-chat-title">Ideas for today and tomorrow</div>
    <LoadingSpinner v-if="!comments" />
    <div class="divider-container"
         v-if="comments.length === 0">
      <ConversationDivider
        dividerText="No ideas yet, add yours!" />
    </div>
    <div>
      <UserGroupComment
        v-for="comment in comments"
        :comment="comment"
        v-bind:key="comment.id"
      />
      <UserGroupMoreCommentsIndicator
        v-if="showViewMore"
        :count="moreCount"
        :groupId="groupId"
      />
      <UserGroupMessageBox
        @message-submitted="update"
        :groupId="groupId"
        :allowTextEntry="context==='page'"
      />
    </div>
  </div>
</template>

<script>
import { fetchComments } from '@/utils/api'
import LoadingSpinner from '@/components/LoadingSpinner'
import UserGroupComment from '@/components/UserGroupComment'
import UserGroupMessageBox from '@/components/UserGroupMessageBox'
import UserGroupMoreCommentsIndicator from '@/components/UserGroupMoreCommentsIndicator'
import ConversationDivider from '@/components/ConversationDivider.vue'

export default {
  name: 'UserGroupChat',
  components: {
    UserGroupMessageBox,
    LoadingSpinner,
    UserGroupComment,
    UserGroupMoreCommentsIndicator,
    ConversationDivider
  },
  props: {
    context: {
      type: String,
      required: true
    }
  },
  data () {
    return {
      comments: null,
      groupId: 1, // fixed for now for worcester parents group
      moreCount: null
    }
  },
  methods: {
    async update () {
      const raw = await fetchComments(this.groupId)
      this.comments = raw.slice(-4)
      console.log(raw.length)
      this.moreCount = raw.length - this.comments.length
    }
  },
  computed: {
    showViewMore () {
      return this.context === 'search' && this.moreCount > 0
    }
  },
  async created () {
    this.update()
  }
}
</script>

<style scoped lang="scss">
.group-chat-title {
  font-size: 16px;
  font-weight: 700;
  margin-bottom: 16px;
}

.home-item {
  position: relative;
  display: flex;
  width: 100%;
  margin-bottom: 16px;
  padding: 20px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-style: none none solid;
  border-width: 1px;
  border-color: #e6e6e6 #e6e6e6 #f3f3f3;
  background-color: #fff;
  box-shadow: none;
}

.divider-container {
  width: 100%;
  margin-top: 32px;
  margin-bottom: 32px;
}

@media (max-width: 767px){
  .home-item {
    margin-top: 8px;
    margin-bottom: 8px;
    padding: 16px;
    border-radius: 0;
  }
  .divider-container {
    margin-top: 16px;
    margin-bottom: 16px;
  }
}
</style>
