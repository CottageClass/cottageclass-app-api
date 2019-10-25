<template>
  <div class="selector-wrapper">
    <v-range-slider
      v-model="range"
      min="0"
      max="18"
      @change="update"
    ></v-range-slider>
    <div>Ages : {{range[0]}} - {{ range[1]}}</div>
  </div>
</template>

<script>
export default {
  name: 'AgeRangeFilterSelector',
  props: ['value'],
  data () {
    return {
      err: null,
      range: [
        this.value.min || 0,
        (this.value.max || this.value.max === 0) ? this.value.max : 18
      ]
    }
  },
  methods: {
    update () {
      this.value.min = this.range[0]
      this.value.max = this.range[1]
      this.$emit('input', this.value)
    }
  },
  watch: {
    value: {
      handler () {
        this.range = [
          this.value.min ? this.value.min : 0,
          this.value.max ? this.value.max : 18
        ]
      },
      deep: true
    }
  }
}
</script>

<style scoped lang="scss">
.selector-wrapper {
  text-align: center;
  padding-top: 16px;
}

.dropdown {
  padding: 16px;
}

.range-dropdown-label {
  padding: 4px;
}
</style>
