<template>
  <span>
    <label
      class="onb-field-label"
    >{{ label }}
    </label>
    <select
      required
      v-if="type ==='select'"
      v-model="fieldValue"
      :type="type || 'text'"
      class="name-text-field w-input"
    >
      <option v-if="placeholder" value="" disabled selected hidden>{{ placeholder }}</option>

      <option v-for="option in selectData" v-bind:value="option.value" >{{ option.text }}</option>
    </select>

    <input v-else
           :type="type || 'text'"
           class="name-text-field w-input"
           :placeholder="placeholder"
           v-model="fieldValue" />

  </span>
</template>

<script>
export default {
  name: 'FormFieldAndLabel',
  props: ['value', 'placeholder', 'label', 'type', 'selectData'],
  data () {
    return {
      fieldValue: this.value
    }
  },
  watch: {
    fieldValue: function () {
      this.$emit('input', this.fieldValue)
    }
  }
}
</script>

<style scoped lang="scss">
select {
  color: black;
}

select:invalid {
  color: #aaa;
}
</style>
