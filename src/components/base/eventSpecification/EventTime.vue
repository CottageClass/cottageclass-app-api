<template>
  <Question
    :title="titleText"
    :subtitle="subtitleText">
    <div class="time-picker-container">
      <a-timePicker class="date-picker"
                    v-model="startTime"
                    use12Hours
                    format="h:mm a"
                    :minuteStep="15"
                    placeholder="start"
                    size="large"
      />
      <a-timePicker class="date-picker"
                    v-model="endTime"
                    use12Hours
                    format="h:mm a"
                    :minuteStep="15"
                    placeholder="end"
                    size="large"
      />
    </div>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'

export default {
  name: 'EventTime',
  props: ['value', 'context'],
  components: { Question },
  data () {
    return {
      startTime: null,
      endTime: null,
      errorMesg: 'Please choose a time when you are available.'
    }
  },
  mounted: function () {
    this.emitData()
  },
  computed: {
    titleText () {
      return 'What times are you available?'
    },
    subtitleText () {
      return 'Choose a time range below. The playdate can be any time in this range.'
    },
    err: function () {
      if (!this.startTime || !this.endTime) {
        return this.errorMesg
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
