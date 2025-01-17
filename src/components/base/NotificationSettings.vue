<template>
  <Question :title="title" >
    <p>Would you like to receive custom weekly emails with suggestions for nearby playdates? </p>
    <RadioButtons
      v-model="settingEmailNotificationsModel"
      :choices="['yes', 'no']" />
    <p class="second-heading">How would you like to be notified of new chat messages from other users?</p>
    <Checkboxes
      :labels="chatLabels"
      v-model="chatMediaModel"
    />
    <p class="second-heading">How would you like to be notified of new group messages?</p>
    <Checkboxes
      :labels="groupLabels"
      v-model="groupMediaModel"
    />
    <p class="second-heading">How would you like to be reminded of your upcoming events?</p>
    <Checkboxes
      :labels="reminderLabels"
      v-model="reminderMediaModel"
    />
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import Checkboxes from '@/components/base/Checkboxes.vue'
import RadioButtons from '@/components/base/RadioButtons.vue'

export default {
  name: 'NotificationSettings',
  components: { Question, Checkboxes, RadioButtons },
  props: {
    value: Object
  },
  data () {
    return {
      chatMediaModel: null,
      groupMediaModel: null,
      reminderMediaModel: null,
      settingEmailNotificationsModel: null
    }
  },
  created () {
    this.initFromValue()
  },
  mounted: function () {
    this.emitData()
  },
  methods: {
    emitData: function () {
      this.$emit('input', {
        chatMedia: this.chatMedia,
        groupMedia: this.groupMedia,
        reminderMedia: this.reminderMedia,
        settingEmailNotifications: this.settingEmailNotificationsModel === 'yes'
      })
    },
    initFromValue () {
      this.chatMediaModel = Object.keys(this.value.chatMedia).reduce((acc, medium) => {
        if (this.value.chatMedia[medium]) {
          return acc.concat(medium)
        } else {
          return acc
        }
      }, [])
      this.groupMediaModel = Object.keys(this.value.groupMedia).reduce((acc, medium) => {
        if (this.value.groupMedia[medium]) {
          return acc.concat(medium)
        } else {
          return acc
        }
      }, [])
      this.reminderMediaModel = Object.keys(this.value.reminderMedia).reduce((acc, medium) => {
        if (this.value.reminderMedia[medium]) {
          return acc.concat(medium)
        } else {
          return acc
        }
      }, [])
      this.settingEmailNotificationsModel = this.value.settingEmailNotifications ? 'yes' : 'no'
    }
  },
  computed: {
    title: () => 'Notification settings',
    chatLabels () {
      return [
        [ 'settingNotifyMessagesPush', 'Push notifications' ],
        [ 'settingNotifyMessagesEmail', 'Email' ],
        [ 'settingNotifyMessagesSms', 'Text message' ]
      ]
    },
    groupLabels () {
      return [
        [ 'settingNotifyGroupMessagesPush', 'Push notifications' ],
        [ 'settingNotifyGroupMessagesEmail', 'Email' ],
        [ 'settingNotifyGroupMessagesSms', 'Text message' ]
      ]
    },
    reminderLabels () {
      return [
        [ 'settingNotifyEventReminderPush', 'Push notifications' ],
        [ 'settingNotifyEventReminderEmail', 'Email' ],
        [ 'settingNotifyEventReminderSms', 'Text message' ]
      ]
    },
    chatMedia () {
      return {
        settingNotifyMessagesPush: this.chatMediaModel.includes('settingNotifyMessagesPush'),
        settingNotifyMessagesEmail: this.chatMediaModel.includes('settingNotifyMessagesEmail'),
        settingNotifyMessagesSms: this.chatMediaModel.includes('settingNotifyMessagesSms')
      }
    },
    groupMedia () {
      return {
        settingNotifyGroupMessagesPush: this.groupMediaModel.includes('settingNotifyGroupMessagesPush'),
        settingNotifyGroupMessagesEmail: this.groupMediaModel.includes('settingNotifyGroupMessagesEmail'),
        settingNotifyGroupMessagesSms: this.groupMediaModel.includes('settingNotifyGroupMessagesSms')
      }
    },
    reminderMedia () {
      return {
        settingNotifyEventReminderPush: this.reminderMediaModel.includes('settingNotifyEventReminderPush'),
        settingNotifyEventReminderEmail: this.reminderMediaModel.includes('settingNotifyEventReminderEmail'),
        settingNotifyEventReminderSms: this.reminderMediaModel.includes('settingNotifyEventReminderSms')
      }
    }
  },
  watch: {
    chatMediaModel () {
      this.emitData()
    },
    groupMediaModel () {
      this.emitData()
    },
    reminderMediaModel () {
      this.emitData()
    },
    settingEmailNotificationsModel () {
      this.emitData()
    }
  }
}
</script>
<style scoped lang="scss">
.second-heading {
  margin-top: 30px;
}
</style>
