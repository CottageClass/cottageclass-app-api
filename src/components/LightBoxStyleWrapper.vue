<template>
  <span class="lightbox-style">
    <slot></slot>
  </span>
</template>

<script>
export default {
  name: 'LightBoxStyleWrapper'
}
</script>

<style lang="scss">

.lightbox-style {
  .vue-lb-container {
    background-color: white;
    color: white;
    }

  .vue-lb-button-close {
    display: none;
    }
}

</style>
