<template>
  <div>
    {{ title }}
    <div class="times-wrapper">
      <MultipleTimeSelectorItem
        v-for="hour in startTimeRange"
        :key="title + hour"
        :startHour="hour"
        :value="isSelected(hour)"
        @input="updated(hour, $event)"
      />
    </div>
  </div>
</template>

<script>
import MultipleTimeSelectorItem from '@/components/base/eventSpecification/MultipleTimeSelectorItem'

export default {
  name: 'MultipleTimeSelectorDay',
  props: ['title', 'firstStartTime', 'lastStartTime', 'value', 'dayIndex'],
  components: { MultipleTimeSelectorItem },
  computed: {
    isSelected () {
      return (hour) => {
        return this.value[hour]
      }
    },
    startTimeRange () {
      return [...Array(this.lastStartTime + 1 - this.firstStartTime).keys()].map(
        e => e + this.firstStartTime
      )
    }
  },
  methods: {
    updated (hour, e) {
      this.$set(this.value, hour, e)
      this.$emit('input', this.value)
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
