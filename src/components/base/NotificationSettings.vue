<template>
  <Question :title="title" >
    <p>Would you like to receive custom weekly emails with suggestions for nearby playdates? </p>
    <RadioButtons
      v-model="settingEmailNotificationsModel"
      :choices="['yes', 'no']" />
    <p class="second-heading">How would you like to be notified of new messages from other users?</p>
    <Checkboxes
      :labels="labels"
      v-model="mediaModel"
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
      mediaModel: null,
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
        media: this.media,
        settingEmailNotifications: this.settingEmailNotificationsModel === 'yes'
      })
    },
    initFromValue () {
      this.mediaModel = Object.keys(this.value.media).reduce((acc, medium) => {
        if (this.value.media[medium]) {
          this.debug(acc)
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
    labels () {
      return [
        [ 'settingNotifyMessagesPush', 'Push notifications' ],
        // [ 'settingNotifyMessagesEmail', 'Email' ],
        [ 'settingNotifyMessagesSms', 'Text message' ]
      ]
    },
    media () {
      return {
        settingNotifyMessagesPush: this.mediaModel.includes('settingNotifyMessagesPush'),
        // settingNotifyMessagesEmail: this.mediaModel.includes('settingNotifyMessagesEmail'),
        settingNotifyMessagesSms: this.mediaModel.includes('settingNotifyMessagesSms')
      }
    }
  },
  watch: {
    // value () {
    // this.initFromValue()
    // },
    mediaModel () {
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
