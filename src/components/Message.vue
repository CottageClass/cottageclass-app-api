<template>
  <div class="chat-detail--message">
    <div class="chat-detail--avatar">
      <router-link
        :to="{name:'UserPage',params:{id:sender.id}}">
        <AvatarImage
          className="image-9"
          :person="sender"
          imageSize="48"
        />
      </router-link>
    </div>
    <div class="chat-detail--text-group">
      <div class="chat-detail--name-time">{{senderName}} <span class="chat-detail--time">{{timeStamp}}</span>
      </div>
      <div class="chat-detail--comment">{{message.content}}</div>
    </div>
  </div>
</template>

<script>
import moment from 'moment'
import { mapGetters } from 'vuex'

import AvatarImage from '@/components/base/AvatarImage'

export default {
  name: 'Message',
  components: { AvatarImage },
  props: {
    partner: { type: Object },
    message: { required: true }
  },
  computed: {
    sender () {
      if (this.message.sender) {
        return this.message.sender
      }
      if (this.message.senderId.toString() === this.partner.id.toString()) {
        return this.partner
      } else {
        return this.currentUser
      }
    },
    senderName () {
      return this.sender.firstName + ' ' + this.sender.lastInitial + '.'
    },
    timeStamp () {
      return moment(this.message.createdAt).format('h:mma')
    },
    ...mapGetters(['currentUser'])
  }
}
</script>

<style scoped lang="scss">
.chat-detail--message {
  min-width: 300px;
  border: 1px black;
  position: relative;
  display: flex;
  padding-top: 16px;
  padding-bottom: 16px;
  flex-direction: row;
  align-items: flex-start;
  background-color: #fff;
}

.image-9 {
  width: 48px;
  height: 48px;
  min-height: 48px;
  min-width: 48px;
  border-radius: 8px;
}

.chat-detail--text-group {
  width: 100%;
  margin-top: -6px;
  padding-right: 16px;
  padding-left: 0;
  background-color: #fff;
}

.chat-detail--name-time {
  font-size: 16px;
  line-height: 24px;
  font-weight: 700;
}

.chat-detail--time {
  color: grey;
  font-size: 14px;
  line-height: 22px;
  font-weight: 400;
}

.chat-detail--comment {
  color: grey;
}

.chat-detail--avatar {
  padding-right: 16px;
  padding-left: 16px;
}
</style>
