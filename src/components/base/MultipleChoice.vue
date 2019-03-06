<template>
    <div class="w-form">
      <form class="onb-form-checkbox-list">

<!-- for radio buttons -->

        <div
        v-if="type=='radio'"
        v-for="(choice, index) in choices"
        class="checkbox-field-extra-space"
        :class="{'active-checkbox': choice === value}">
          <input
          type="radio"
          :id="choice"
          :value="choice"
          :name="choice"
          class="onb-checkbox w-checkbox-input"
          v-model="vModelProxy"
          >
          <label
          :for="choice"
          class="onb-checkbox-label w-form-label"
          >
           {{ capitalize(choicesOrLabels[index]) }}
         </label>
        </div>

<!-- for checkboxes -->

        <div
        v-if="type=='checkbox'"
        v-for="(key, index) in keys"
        class="checkbox-field-extra-space"
        :class="{'active-checkbox': objValues[index]}"
        >

<!-- for objects with checkboxes -->

          <input
          v-if="vModelIs=='object'"
          v-model="value[key]"
          type="checkbox"
          :id="index"
          :name="index"
          class="onb-checkbox w-checkbox-input"
          :class="{ 'active-checkbox': objValues[index] }">

<!-- for arrays with checkboxes -->

          <input
          v-if="vModelIs=='array'"
          @click="toggleSelected(key)"
          type="checkbox"
          :id="index"
          :name="index"
          class="onb-checkbox w-checkbox-input"
          :checked="objValues[index]"
          :class="{ 'active-checkbox': objValues[index] }">
          <label :for="index" class="onb-checkbox-label w-form-label">
            {{ keysOrLabels[index] }}
          </label>

        </div>
      </form>
    </div>
</template>

<script>
import * as utils from '@/utils/utils.js'
export default {

// labelsAndOrder is an array of arrays [key, label] and is optional, for when label names are different than key names. It determines the order.
// value is an array of ids or an object of keys and values. if an array of ids, v-model returns ids.

  name: 'MultipleChoice',
  props: ['value', 'labelsAndOrder', 'type', 'choices'],
  computed: {
    keys: function () {
      if (this.labelsAndOrder) {
        return this.labelsAndOrder.map(pair => pair[0])
      } else {
        return []
      }
    },
    objValues: function () {
      if ((this.type != 'radio') && (this.vModelIs != 'array')) {
        return this.keys.map(key => this.value[key])
      } else if ((this.type != 'radio') && (this.vModelIs === 'array')) {
        return this.keys.map(key => this.value.includes(key))
      } else {
        return []
      }
    },
    keysOrLabels: function () {
      if (this.labelsAndOrder) {
        return this.labelsAndOrder.map(pair => pair[1])
      } else {
        return this.keys
      }
    },
    choicesOrLabels: function () {
      if (this.labelsAndOrder) {
        return this.labelsAndOrder.map(pair => pair[1])
      } else {
        return this.choices
      }
    },
    vModelIs: function () {
      if (Array.isArray(this.value)) {
        return 'array'
      } else {
        return typeof this.value
      }
    },
    vModelProxy: {
      get () { return this.value },
      set (v) { this.$emit('input', v) }
    }
  },
  methods: {
    capitalize: utils.capitalize,
    toggleSelected: function (key) {
      if (this.value.includes(key)) {
        this.value = this.value.filter(item => item != key)
      } else {
        this.value = this.value.push(key)
      }
    }
  },
  watch: {
    value: function () {
        this.$emit('input', this.value)
      },
  }
}
</script>

<style lang="scss" scoped>

.onb-checkbox {
    margin-top: 22px;
}

</style>
