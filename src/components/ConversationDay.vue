<template>
  <div>
    <ConversationDivider
      v-if="showDivider"
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
    partner: { type: Object, required: true },
    day: { type: String, required: true },
    messages: { type: Array, required: true }
  },
  components: { Message, ConversationDivider },
  computed: {
    showDivider () {
      return this.day !== moment().format('YYYY-MM-DD')
    },
    dayText () {
      const formatString = 'ddd, MMM D, YYYY'
      const today = moment().format(formatString)
      const yesterday = moment().subtract(1, 'days').format(formatString)
      const formattedDay = moment(this.day).format(formatString)

      if (today === formattedDay) { return '' }
      if (yesterday === formattedDay) { return 'Yesterday' }
      return formattedDay
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
</style>
