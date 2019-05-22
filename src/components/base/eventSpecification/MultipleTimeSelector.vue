<template>
  <div>
    <Question
      title="When are you available?"
      :subtitle="subtitle" >
      <div v-for="(dow, dayIndex) of shiftedDayIndices">
        <MultipleTimeSelectorDay
           class="day-of-week"
           :title="dayName(dow)"
           :firstStartTime="firstTime(dayIndex)"
           :lastStartTime="lastTime(dayIndex)"
           :value="value.availability[dow]"
           />
      </div>
    </Question>
  </div>
</template>

<script>
import MultipleTimeSelectorDay from '@/components/base/eventSpecification/MultipleTimeSelectorDay'
import Question from '@/components/base/Question.vue'

export default {
  name: 'MultipleTimeSelector',
  props: ['value', 'firstDisplay'],
  components: { MultipleTimeSelectorDay, Question },
  computed: {
    subtitle () {
      return "When are you available for the idea you're offering? The more options you give other families, the more likely you are to get a response."
    },
    dayName () {
      return (index) => {
        const WEEK_DAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
        return WEEK_DAYS[index]
      }
    },
    firstDay () {
      if (this.todayType === 'late') {
        return Math.floor(this.firstDisplay / 24) + 1
      }
      return Math.floor(this.firstDisplay / 24)
    },
    todayType () {
      // "today" is the day associated with firstDisplay.  it's possible nothing is shown on today if it's too late already
      if (this.todayTime <= 8) {
        return 'early' // show the entirety of today
      }
      if (this.todayTime >= 23) {
        return 'late' // don't show anything on today
      }
      return 'midday' // show some of today
    },
    todayTime () {
      return Math.max(8, this.firstDisplay % 24)
    },
    firstTime () {
      return (dayIndex) => {
        if (dayIndex > 0) {
          return 8
        } else {
          if (this.todayType === 'midday') {
            return Math.max(8, this.firstDisplay % 24)
          } else {
            return 8
          }
        }
      }
    },
    lastTime () {
      return (dayIndex) => {
        if (dayIndex < 7) {
          return 23
        } else {
          return Math.max(8, this.firstDisplay % 24) - 1
        }
      }
    },
    shiftedDayIndices () {
      if (this.todayType === 'midday') {
        return [0, 1, 2, 3, 4, 5, 6, 7].map(i => (i + this.firstDay) % 7)
      } else {
        return [0, 1, 2, 3, 4, 5, 6].map(i => (i + this.firstDay) % 7)
      }
    }
  }
}
</script>

<style scoped>
.day-of-week {
}

</style>
