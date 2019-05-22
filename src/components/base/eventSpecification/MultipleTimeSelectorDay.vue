<template>
  <div class="day-container">
    <div class="day-title">
      {{ title }}
    </div>
    <div class="times-wrapper">
      <MultipleTimeSelectorItem
        class="item-container"
        v-for="hour in startTimeRange"
        :key="title + hour"
        :startHour="hour"
        v-model="value[hour]"
      />
      <!-- dummy containers to ensure wrapping works properly -->
      <div class="dummy-item-container" />
      <div class="dummy-item-container" />
      <div class="dummy-item-container" />
      <div class="dummy-item-container" />
      <div class="dummy-item-container" />
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
.dummy-item-container, .item-container {
  width: 24%;
}
.dummy-item-container {
  height: 0;
}
.item-container {
  &.active {
    background-color:white;
    &:hover {
      background-color: #F0F0F0;
    }
  }
  &.inactive:hover {
    background-color: #BCCDEF;
  }
  background-color: #BCDDF7;
  border-radius: 4px;
  color: #158BE7;
  padding: 5px;
  margin: 3px 2px;
  font-variant: small-caps;
  width: 24%;
  text-align: center;
  cursor: pointer;
}
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
@media (max-width: 479px) {
  .dummy-item-container, .item-container {
    width: 31%;
  }
}
</style>
