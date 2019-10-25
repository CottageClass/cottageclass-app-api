<template>
  <div class="contents">
    {{ buttonText }}
  </div>
</template>

<script>
import moment from 'moment'

export default {
  name: 'EventTimeFilterButton',
  props: ['eventTime'],
  computed: {
    buttonText () {
      if (this.weekdayName) {
        return this.weekdayName
      }
      if (this.dateName) {
        return this.dateName
      }
      return 'Date'
    },
    dateName () {
      return this.eventTime.date && moment(this.eventTime.date).format('MMM D')
    },
    weekdayName () {
      const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
      if (this.eventTime.weekday || this.eventTime.weekday === 0) {
        return weekdays[this.eventTime.weekday]
      }
      return null
    }
  }
}
</script>

<style scoped>
.contents {
  text-align: center;
}
</style>
