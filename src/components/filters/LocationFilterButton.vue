<template>
  <div class="contents">
    {{ shortDescription || 'Distance'}}
  </div>
</template>

<script>
export default {
  name: 'LocationFilterButton',
  props: ['shortDescription']
}
</script>

<style scoped>
.contents {
  text-align: center;
}
</style>
