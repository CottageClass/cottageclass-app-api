<template>
  <div class="selector-wrapper">
    <v-date-picker class="date-picker"
                   type="date"
                   :allowedDates="allowedDates"
                   v-model="dateSelected" />
  </div>
</template>

<script>
import moment from 'moment'

export default {
  name: 'EventTimeFilterSelector',
  props: ['value'],
  data () {
    return {
      err: null,
      dateSelected: ''
    }
  },
  computed: {
    allowedDates () {
      return (date) => {
        const yearFromNow = moment(new Date()).add(1, 'years')
        const yesterday = moment(new Date()).add(-1, 'days')
        return moment(date).isAfter(yesterday) && moment(date).isBefore(yearFromNow)
      }
    }
  },
  methods: {
    update () {
      this.$emit('input', this.value)
    }
  }
}
</script>

<style scoped lang="scss">
.selector-wrapper {
  height: 400px;
  text-align: center;
  padding-top: 16px;
}

.dropdown {
  padding: 16px;
}

</style>
