<template>
  <div class="day-container">
    <div class="day-title">
      {{ title }}
    </div>
    <div class="times-wrapper">
      <MultipleTimeSelectorItem
        v-for="hour in startTimeRange"
        :key="title + hour"
        :startHour="hour"
        v-model="value[hour]"
      />
    </div>
  </div>
</template>

<script>
import MultipleTimeSelectorItem from '@/components/base/eventSpecification/MultipleTimeSelectorItem'

export default {
  name: 'MultipleTimeSelectorDay',
  props: ['title', 'firstStartTime', 'lastStartTime', 'value'],
  components: { MultipleTimeSelectorItem },
  computed: {
    startTimeRange () {
      return [...Array(this.lastStartTime + 1 - this.firstStartTime).keys()].map(
        e => e + this.firstStartTime
      )
    }
  }
}
</script>

<style scoped>
.times-wrapper {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: space-between;
}
.day-title {
  color: white;
  margin-bottom: 8px;

}
.day-container {
  margin-bottom: 20px;
}
</style>
