<template>
  <span>
    <label
      class="onb-field-label"
    >{{ label }}
    </label>
    <select
      v-if="type ==='select'"
      v-model="fieldValue"
      :type="type || 'text'"
      class="name-text-field w-input"
      :placeholder="placeholder">
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
