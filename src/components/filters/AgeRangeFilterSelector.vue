<template>
  <div class="selector-wrapper">
    <v-range-slider
      v-model="range"
      min="0"
      max="11"
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
      range: [this.value.data.min, this.value.data.max]
    }
  },
  methods: {
    update () {
      this.value.data.min = this.range[0]
      this.value.data.max = this.range[1]
      this.$emit('input', this.value)
    }
  },
  created () {
    this.range = [this.value.data.min >= 0 ? this.value.data.min : 0,
      this.value.data.max >= 0 ? this.value.data.max : 11]
  },
  watch: {
    value () {
      this.range = [this.value.data.min >= 0 ? this.value.data.min : 0,
        this.value.data.max >= 0 ? this.value.data.max : 11]
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
