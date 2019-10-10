<template>
  <Question
    title="What time will it be?"
    subtitle="Please choose a start and end time for your playdate.">
    <div class="time-picker-container">
      <a-timePicker class="date-picker"
                    v-model="startTime"
                    use12Hours
                    format="h:mm a"
                    :minuteStep="15"
                    placeholder="start"
                    size="large"
                    :defaultOpenValue="beginningOfToday"
      />
      <a-timePicker class="date-picker"
                    v-model="endTime"
                    use12Hours
                    format="h:mm a"
                    :minuteStep="15"
                    placeholder="end"
                    size="large"
                    :defaultOpenValue="beginningOfToday"
      />
    </div>
  </Question>
</template>

<script>
import moment from 'moment'

import Question from '@/components/base/Question.vue'

export default {
  name: 'EventTime',
  props: ['value', 'context'],
  components: { Question },
  data () {
    return {
      startTime: null,
      endTime: null
    }
  },
  mounted: function () {
    this.emitData()
  },
  computed: {
    beginningOfToday () {
      return moment().startOf('day')
    },
    err: function () {
      if (!this.startTime || !this.endTime) {
        return 'Please choose a start and end time for your event'
      } else if (moment(this.startTime) >= moment(this.endTime)) {
        return 'Your start time must be before your end time.'
      } else {
        return false
      }
    }
  },
  methods: {
    emitData () {
      this.$emit('input', {
        start: this.startTime && this.startTime.format('HH:mm'),
        end: this.endTime && this.endTime.format('HH:mm'),
        err: this.err
      })
    }
  },
  watch: {
    startTime: {
      handler: function () {
        this.emitData()
      }
    },
    endTime () {
      this.emitData()
    }
  }
}
</script>
<style scoped lang="scss">
.time-picker-container {
  display: flex;
  flex-direction: row;
  justify-content: space-around;
}
</style>
