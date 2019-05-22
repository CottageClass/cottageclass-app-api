<template>
  <div class="item-container"
       @click="toggleSelected"
       :class="value?'active':'inactive'">
    <div class="time-label">
      {{ timeText }}
    </div>
  </div>
</template>

<script>

export default {
  name: 'MultipleTimeSelectorItem',
  props: ['startHour', 'value'],
  components: {},
  computed: {
    timeText () {
      return this.toCompactTime(this.startHour) + '-' + this.toCompactTime((this.startHour + 1) % 24)
    },
    toCompactTime () {
      return hour => (hour + 11) % 12 + 1 + (hour < 12 ? 'am' : 'pm')
    }
  },
  methods: {
    toggleSelected () {
      this.$emit('input', !this.value)
    }
  }
}
</script>

<style scoped>
.item-container.active {
  background-color:white;
}
.item-container {
  background-color: #BCDDF7;
  border-radius: 4px;
  color: #158BE7;
  padding: 5px;
  margin: 3px 2px;
  font-variant: small-caps;
  width: 31%;
  text-align: center;
}
</style>
