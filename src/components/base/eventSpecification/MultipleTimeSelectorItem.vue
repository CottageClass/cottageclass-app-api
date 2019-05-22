<template>
  <div @click="toggleSelected"
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
