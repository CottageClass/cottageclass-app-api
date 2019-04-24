<template>
  <div class="wrapper">
    <div class="dropdown">
      <div class="label">Minimum</div>
    <select v-model="value.data.min" @change="updateMin">
      <option value="-1" selected>-</option>
      <option v-for="age in Array(12).keys()"
              :key="'min-age-range-' + age"
              :value="age"
              >
              {{age}}
      </option>
    </select>
    </div>
    <div class="dropdown">
    <div class="label">Maximum</div>
    <select v-model="value.data.max" @change="updateMax">
      <option value="-1" selected>-</option>
      <option v-for="age in Array(12).keys()"
              :key="'max-age-range-' + age"
              :value="age"
              >
              {{age}}
      </option>
    </select>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AgeRangeFilter',
  props: ['value'],
  data () {
    return {
      err: null
    }
  },
  methods: {
    update () {
      this.$emit('input', this.value)
    },
    updateMax () {
      if (this.value.data.max >= 0 && this.value.data.min >= 0 && this.value.data.min > this.value.data.max) {
        this.value.data.min = this.value.data.max
      }
      this.update()
    },

    updateMin () {
      if (this.value.data.min >= 0 && this.value.data.max >= 0 && this.value.data.min > this.value.data.max) {
        this.value.data.max = this.value.data.min
      }
      this.update()
    }
  }
}
</script>

<style>
.wrapper {
  text-align: center;
  padding-top: 16px;
}

.dropdown {
  padding: 16px;
}

.label {
  padding: 4px;
}
</style>
