<template>
  <div>
    {{ title }}
    <div class="times-wrapper">
      <MultipleTimeSelectorItem
        v-for="hour in startTimeRange"
        v-bind:key="title + hour"
        :startHour="hour"
        :selected="value[hour]"
        :value=value[hour]
        @input="selectionChanged"
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
  },
  methods: {
    selectionChanged (e) {
      this.$set(this.value, e.hour, e.selected)
    }
  }
}
</script>

<style scoped>
.times-wrapper {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
}
</style>
