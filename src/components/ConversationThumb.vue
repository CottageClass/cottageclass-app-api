<template>
  <li class="chat-detail--message">
    <div class="chat-detail--avatar">
      <AvatarImage
        className="image-9"
        :person="partner"
        imageSize="48"
      />
    </div>
    <div class="chat-detail--text-group">
      <div class="chat-detail--name-time">{{partnerName}}</div>
      <div class="chat-detail--comment line-clamp--2">{{messagePreview}}</div>
      <div class="text-block-12">{{messageTimestamp}}</div>
    </div>
    <router-link
      :to="{name: 'Conversation', params: {userId: partner.id}}"
      class="entry__hyperlink w-inline-block"/>
  </li>
</template>

<script>
import moment from 'moment'
import AvatarImage from '@/components/base/AvatarImage'

export default {
  name: 'ConversationThumb',
  components: { AvatarImage },
  props: {
    conversation: { required: true }
  },
  computed: {
    partner () {
      return this.conversation.partner
    },
    message () {
      return this.conversation.message
    },
    partnerName () {
      return this.partner.firstName + ' ' + this.partner.lastInitial + '.'
    },
    messagePreview () {
      return this.message.content
    },
    messageTimestamp () {
      return moment(this.message.createdAt).format('MMM D, YYYY')
    }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.entry__hyperlink {
  position: absolute;
  left: 0%;
  top: 0%;
  right: auto;
  bottom: auto;
  z-index: 0;
  display: block;
  width: 100%;
  height: 100%;
  min-height: 100%;
  min-width: 100%;
  background-color: transparent;
}

.entry__hyperlink:hover {
  background-color: rgba(0, 0, 0, 0.03);
}

.chat-detail--message {
  position: relative;
  display: flex;
  padding-top: 16px;
  padding-bottom: 16px;
  flex-direction: row;
  align-items: flex-start;
  background-color: #fff;
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

.chat-detail--comment {
  color: grey;
}
.image-9 {
  width: 48px;
  height: 48px;
  min-height: 48px;
  min-width: 48px;
  border-radius: 8px;
}
.chat-detail--avatar {
  padding-right: 16px;
  padding-left: 16px;
}

.text-block-12 {
  color: rgba(0, 0, 0, 0.3);
  font-size: 12px;
  line-height: 20px;
}

@media (max-width: 991px){
  .entry__hyperlink {
    background-color: transparent;
  }

  .entry__hyperlink:hover {
    background-color: transparent;
  }

  .entry__hyperlink:active {
    background-color: rgba(0, 0, 0, 0.03);
  }

}
</style>
