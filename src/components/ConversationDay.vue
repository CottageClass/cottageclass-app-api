<template>
  <div>
    <ConversationDivider
      :dividerText="dayText"
    />
    <Message v-for="message in sortedMessages"
             :key="message.id"
             :message="message"
             :partner="partner"/>
  </div>
</template>

<script>
import moment from 'moment'
import ConversationDivider from '@/components/ConversationDivider.vue'
import Message from '@/components/Message'

export default {
  name: 'ConversationDay',
  props: {
    partner: { type: Object },
    day: { type: String, required: true },
    messages: { type: Array, required: true }
  },
  components: { Message, ConversationDivider },
  computed: {
    dayText () {
      const formatString = 'ddd, MMM D, YYYY'
      const today = moment().format(formatString)
      const yesterday = moment().subtract(1, 'days').format(formatString)
      const formattedDay = moment(this.day).format(formatString)

      if (today === formattedDay) { return 'Today' }
      if (yesterday === formattedDay) { return 'Yesterday' }
      return formattedDay
    },
    sortedMessages () {
      return this.messages.concat().sort((a, b) => {
        const date1 = new Date(b.createdAt)
        const date2 = new Date(a.createdAt)
        return date2 - date1
      })
    }
  }
}
</script>

<style scoped lang="scss">
</style>
