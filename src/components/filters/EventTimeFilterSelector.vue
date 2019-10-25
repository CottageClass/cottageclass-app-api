<template>
  <div class="selector-wrapper">
    <v-date-picker class="date-picker"
                   type="date"
                   :allowedDates="allowedDates"
                   v-model="dateSelected" />
    <div class="weekday-options">
      <button v-for="weekday in weekdays"
              class='weekday-option'
              :class="{selected: weekday === weekdaySelected}"
              @click="weekdayClicked(weekday)">
        {{weekday}}
      </button>
    </div>
  </div>
</template>

<script>
import moment from 'moment'

const WEEKDAYS = ['Su', 'M', 'Tu', 'W', 'Th', 'F', 'Sa']

export default {
  name: 'EventTimeFilterSelector',
  props: ['value'],
  data () {
    return {
      err: null,
      dateSelected: this.value.date,
      weekdaySelected: WEEKDAYS[this.value.weekday]
    }
  },
  computed: {
    weekdays: _ => WEEKDAYS,
    allowedDates () {
      return (date) => {
        const yearFromNow = moment(new Date()).add(1, 'years')
        const yesterday = moment(new Date()).add(-1, 'days')
        return moment(date).isAfter(yesterday) && moment(date).isBefore(yearFromNow)
      }
    }
  },
  watch: {
    value: {
      handler () {
        this.dateSelected = this.value.date
        this.weekdaySelected = WEEKDAYS[this.value.weekday]
      },
      deep: true
    },
    dateSelected () {
      if (this.dateSelected) {
        this.weekdaySelected = null
      }
      this.update()
    }
  },
  methods: {
    weekdayClicked (weekday) {
      this.dateSelected = null
      if (this.weekdaySelected === weekday) {
        this.weekdaySelected = null
      } else {
        this.weekdaySelected = weekday
      }
      this.update()
    },
    update () {
      this.$emit('input', {
        date: this.dateSelected,
        weekday: this.weekdaySelected && WEEKDAYS.indexOf(this.weekdaySelected)
      })
    }
  }
}
</script>

<style scoped lang="scss">
.weekday-options {
  padding-top: 20px;
  margin-top: 20px;
  border-top: 1px solid black;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  width: 100%;
}
.weekday-option {
  border: 1px solid grey;
  border-radius: 2px;
  background: #bbb;
  padding: 4px 8px;
  &.selected {
    background-color: white;
    border-color: black;
  }
}
.selector-wrapper {
  text-align: center;
  padding-top: 16px;
}

.dropdown {
  padding: 16px;
}

</style>
