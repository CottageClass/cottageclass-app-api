<template>
  <div>
    <Question
      title="What times work for you?"
      subtitle="When are you available to host the playdate you're offering? The more choices you give other families, the easier it will be to schedule a fun playdate!" >
      <div @click="$emit('datetimeClicked')"
          class="date-time-button">
        offer one time only
      </div>
      <div v-for="(dow, dayIndex) of shiftedDayIndices">
        <MultipleTimeSelectorDay
           class="day-of-week"
           :title="dayTitle(dayIndex)"
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

import moment from 'moment'
import { momentToLocalWeekHour } from '@/utils/time'

export default {
  name: 'MultipleTimeSelector',
  props: ['value', 'scheduleStartTime'],
  components: { MultipleTimeSelectorDay, Question },
  computed: {
    dayTitle () {
      return (dayIndex) => {
        const daysToAdd = this.todayType === 'late' ? 1 + dayIndex : dayIndex
        return moment().add(daysToAdd, 'days').format('dddd, MMMM Do')
      }
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
    firstDisplay () {
      return momentToLocalWeekHour(this.scheduleStartTime) + 1 % (7 * 24)
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
    },
    errorMessage () {
      const someTimeSelected = this.value.availability.some(day => day.some(e => e))
      if (someTimeSelected) {
        return null
      } else {
        return 'Please select at least one time slot'
      }
    },
    availability () {
      return this.value.availability
    }
  },
  watch: {
    availability: {
      handler: function () {
        this.value.err = this.errorMessage
      },
      deep: true,
      immediate: true
    }
  }
}
</script>

<style scoped>
.date-time-button {
  &:hover {
    background-color: #F0F0F0;
  }
  background-color:white;
  border-radius: 4px;
  color: #158BE7;
  padding: 12px 5px;
  font-variant: small-caps;
  width: 40%;
  text-align: center;
  cursor: pointer;
  margin-right: auto;
  margin-left: auto;
  margin-top: 3px;
  margin-bottom: 32px;
}
@media (max-width: 479px) {
  .date-time-button {
    width: 60%;
  }
}

</style>
