<template>
  <div class="wrapper">
    <select v-model="value.data.min" @change="update">
      <option value="-1" selected>-</option>
      <option v-for="age in Array(12).keys()"
              :key="'min-age-range-' + age"
              :value="age"
              >
              {{age}}
      </option>
    </select><br>
    <select v-model="value.data.max" @change="update">
      <option value="-1" selected>-</option>
      <option v-for="age in Array(12).keys()"
              :key="'max-age-range-' + age"
              :value="age"
              >
              {{age}}
      </option>
    </select>
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
    }
  }
}
</script>

<style>

</style>
