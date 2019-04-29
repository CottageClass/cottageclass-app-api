<template>
  <div class="contents">
    {{ zipCode || 'Location'}}
  </div>
</template>

<script>
export default {
  name: 'LocationFilterButton',
  props: ['zipCode']
}
</script>

<style scoped>
.contents {
  text-align: center;
}
</style>
