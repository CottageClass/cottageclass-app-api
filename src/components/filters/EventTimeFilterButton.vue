<template>
  <div class="contents">
    {{ buttonText }}
  </div>
</template>

<script>
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
      return this.eventTime.date
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
