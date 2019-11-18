<template>
  <div class="contents">
    {{ buttonText }}
  </div>
</template>

<script>
export default {
  name: 'LocationFilterButton',
  props: ['shortDescription', 'maxDistance'],
  computed: {
    buttonText () {
      if (this.shortDescription && this.maxDistance) {
        return `${this.shortDescription} • ${this.maxDistance} mi.`
      }
      if (this.shortDescription) {
        return this.shortDescription
      }
      if (this.maxDistance) {
        return `${this.maxDistance} mi.`
      }
      return 'Distance'
    }
  }
}
</script>

<style scoped>
.contents {
  text-align: center;
}
</style>
