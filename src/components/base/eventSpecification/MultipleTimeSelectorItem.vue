<template>
  <div class="item-container"
       @click="toggleSelected"
       :class="selected?'active':'inactive'">
    <div class="time-label">
      {{ timeText }}
    </div>
  </div>
</template>

<script>

export default {
  name: 'MultipleTimeSelectorItem',
  props: ['startHour', 'selected'],
  components: {},
  computed: {
    timeText () {
      return this.toCompactTime(this.startHour) + ' - ' + this.toCompactTime((this.startHour + 1) % 24)
    },
    toCompactTime () {
      return hour => (hour + 11) % 12 + 1 + (hour < 12 ? 'am' : 'pm')
    }
  },
  methods: {
    toggleSelected () {
      this.$emit('input', { hour: this.startHour, selected: !this.selected })
    }
  }
}
</script>

<style scoped>
.active {
  background-color:red;
}
.item-container {
  margin: 4px;
  width: 100px;
  border: 1px solid white;
}
</style>
