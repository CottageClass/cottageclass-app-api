<template>
  <div class="contents">
    {{ buttonText }}
  </div>
</template>

<script>
export default {
  name: 'AgeRangeFilterButton',
  props: ['range'],
  computed: {
    buttonText () {
      if (!this.range.data) {
        return 'Age Range'
      }
      let { min, max } = this.range.data
      if (min < 0) {
        min = null
      } else {
        min = min.toString()
      }
      if (max < 0) {
        max = null
      } else {
        max = max.toString()
      }

      if (min && max) {
        return min + ' - ' + max
      }
      if (min && !max) {
        return min + ' and Up'
      }
      if (!min && max) {
        return 'Up to ' + max
      }
      return 'Age range'
    }
  }
}
</script>

<style scoped>
.contents {
  width: 62px;
}
</style>
