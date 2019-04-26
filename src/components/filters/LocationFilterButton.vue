<template>
  <div class="contents">
    {{ zipCode || 'zzz'}}
  </div>
</template>

<script>
export default {
  name: 'AgeRangeFilterButton',
  props: ['zipCode']
}
</script>

<style scoped>
.contents {
  text-align: center;
}
</style>
