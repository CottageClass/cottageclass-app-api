<template>
  <div class="chat-detail--month">
    <div class="divider"></div>
    <div class="text-white-background">
      <div v-if="showDivider" class="chat-detail--month-text">{{monthText}}</div>
      <Message v-for="message in sortedMessages"
               :key="message.id"
               :message="message"
               :partner="partner"/>
    </div>
  </div>
</template>

<script>
import moment from 'moment'

import Message from '@/components/Message'

export default {
  name: 'ConversationMonth',
  props: {
    partner: { type: Object, required: true },
    month: { type: String, required: true },
    messages: { type: Array, required: true }
  },
  components: { Message },
  computed: {
    showDivider () {
      return this.month !== moment().format('YYYY-MM')
    },
    monthText () {
      return moment(this.month).format('MMM YYYY')
    },
    sortedMessages () {
      return this.messages.concat().sort((a, b) => {
        const date1 = new Date(b.createdAt)
        const date2 = new Date(a.createdAt)
        return date1 - date2
      })
    }
  }
}
</script>

<style scoped lang="scss">
.chat-detail--month {
  position: relative;
  display: flex;
  padding-bottom: 12px;
  flex-direction: column;
  align-items: center;
  background-color: #fff;
}

.chat-detail--month-text {
  position: static;
  top: 108px;
  width: 100%;
  background-color: transparent;
  color: #b3b3b3;
  text-align: center;
}

.divider {
  position: absolute;
  left: 0%;
  top: 10px;
  right: 0%;
  bottom: auto;
  z-index: 0;
  width: 100%;
  height: 1px;
  min-height: 1px;
  background-color: rgba(0, 0, 0, 0.06);
}

.text-white-background {
  position: relative;
  z-index: 0;
  padding-right: 8px;
  padding-left: 8px;
  flex: 0 auto;
  background-color: #fff;
}
</style>
