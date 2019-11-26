<template>
  <span>
    <div class="onb-group-header">
      <h2 class="onb-child-group-heading">{{ heading }}</h2>
      <a
        v-if="showRemoveButton && this.value.key > 0"
        @click="$emit('remove')"
        class="onb-button-remove-group-text w-inline-block">
        Remove</a>
    </div>
    <FormFieldAndLabel
      v-for="fieldGroup in fieldGroups"
      v-model="objectOfFormValues[fieldGroup.name]"
      :label="fieldGroup.label"
      :placeholder="fieldGroup.placeholder"
      :key="fieldGroup.name"
      :type="fieldGroup.type"
      :selectData="fieldGroup.selectData"
    />
  </span>
</template>

<script>
import FormFieldAndLabel from '@/components/base/FormFieldAndLabel.vue'
export default {
  name: 'FormFieldGroup',
  components: { FormFieldAndLabel },
  props: [
    'fieldGroups',
    'value', // an array of form entry values from v-model
    'labels', // an array of corresponding field labels
    'names', // an array of key names
    'placeholders', // an array of corresponding form placeholder text
    'heading', // the heading of the group of fields
    'types', // and array of input types for each field
    'showRemoveButton', // show a remove button on each item
    'selectData' // an array of options for select questions
  ],
  data () {
    return {
      objectOfFormValues: this.value
    }
  },
  watch: {
    fieldValues: function () {
      this.$emit('input', this.fieldValues)
    }
  }
}
</script>

<style lang="scss" scoped>
.editing {
  .onb-child-group-heading {
    margin-bottom: 8px;
    font-size: 17px;
    font-weight: 700;
    line-height: 24px;
  }
}

.flow {
  .onb-button-remove-group-text {
  padding: 3px 10px;
  border-style: solid;
  border-width: 1px;
  border-color: #fb6f77;
  border-radius: 4px;
  background-color: #fff;
  color: #fb6f77;
  font-size: 13px;
  }

  .onb-button-remove-group-text:active {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
  }
  .onb-child-group-heading {
    margin-top: 0px;
    margin-bottom: 0px;
    font-size: 16px;
    line-height: 16px;
    font-weight: 400;
  }
  .onb-group-header {
    display: flex;
    height: 50px;
    margin-bottom: 24px;
    justify-content: space-between;
    align-items: center;
  }
  .image-6 {
    opacity: 0.7;
  }
}
</style>
