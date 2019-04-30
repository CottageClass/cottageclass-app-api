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
        return 'Ages 0-11'
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
        return min + ' and up'
      }
      if (!min && max) {
        return max + ' & under'
      }
      return 'Ages 0-11'
    }
  }
}
</script>

<style scoped>
.contents {
  text-align: center;
}
</style>
