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

<style lang="scss" scoped src="@/assets/style/scss/editing.scss"></style>

<style scoped lang="scss">
.flow {
  .name-text-field {
  height: 56px;
  padding-top: 8px;
  padding-left: 18px;
  border-style: solid;
  border-width: 1px;
  border-color: #e4e4e4;
  border-radius: 4px;
  background-color: #f0f0f0;
  font-size: 16px;
  }

  .name-text-field:focus {
  border-color: #0dba52;
  background-color: #fff
  }

  .name-text-field::-webkit-input-placeholder {
    color: rgba(0, 0, 0, .3);
  }

  .name-text-field:-ms-input-placeholder {
    color: rgba(0, 0, 0, .3);
  }

  .name-text-field::placeholder {
    color: rgba(0, 0, 0, .3);
  }

  .onb-field-label {
    margin-top: 24px;
    margin-bottom: 8px;
    color: #fff;
    font-weight: 700;
  }
  select {
    color: black;
  }

  select:invalid {
    color: #aaa;
  }
}
</style>
