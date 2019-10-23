<template>
  <Question
    title="What time?"
    subtitle="Please choose a start and end time for your playdate.">
    <div class="time-picker-container">
      <a-timePicker class="date-picker"
                    v-model="startTime"
                    use12Hours
                    format="h:mm a"
                    :minuteStep="15"
                    placeholder="Start time"
                    size="large"
                    :defaultOpenValue="beginningOfToday"
                    :inputReadOnly="true"
      />
      <a-timePicker class="date-picker"
                    v-model="endTime"
                    use12Hours
                    format="h:mm a"
                    :minuteStep="15"
                    placeholder="End time"
                    size="large"
                    :defaultOpenValue="beginningOfToday"
                    :inputReadOnly="true"
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
      startTime: this.value.start ? moment(this.value.start, 'HH:mm') : null,
      endTime: this.value.end ? moment(this.value.end, 'HH:mm') : null
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

.date-picker {
  margin: 0 4px;
  width: 150px;
}

.time-picker-container {
  display: flex;
  flex-direction: row;
  justify-content: center;
}
</style>
