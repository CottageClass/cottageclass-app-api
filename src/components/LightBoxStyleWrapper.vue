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
  svg {
    fill: rgba(0, 0, 0, 0.7);
  }
  .vue-lb-footer-count {
    color: #333;
  }
  .vue-lb-container {
    background-color: white;
    color: white;
    }
  .vue-lb-modal-thumbnail-active {
    box-shadow: inset 0 0 0 2px #fd6f77
  }

}

</style>
