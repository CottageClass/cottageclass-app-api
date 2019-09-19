<template>
  <div class="w-form">
    <form class="onb-form-checkbox-list">
      <div
        v-for="(choice, index) in choices"
        :key="'r-' + _uid + '-' + index"
        class="checkbox-field-extra-space"
        :class="{'active-checkbox': choice === state}">
        <input
          type="radio"
          :id="statePrefix + choice"
          :value="statePrefix + choice"
          :name="statePrefix + choice"
          class="onb-checkbox w-checkbox-input"
          v-model="state"
        >
        <label :for="statePrefix + choice" class="onb-checkbox-label w-form-label">
          {{ getLabel(index) }}
        </label>
      </div>
    </form>
  </div>
</template>

<script>

export default {
  name: 'RadioButtons',
  props: ['value', 'choices', 'labels'],
  data: () => {
    return { state: null }
  },
  watch: {
    value: function () {
      // update the state if the props change, after a fetch or something
      this.state = this.statePrefix + this.value
    },
    state: function () {
      this.$emit('input', this.state.split(this.statePrefix)[1])
    }
  },
  mounted: function () {
    this.state = 'rb-' + this._uid + '-' + this.value
  },
  computed: {
    statePrefix () {
      return 'rb-' + this._uid + '-'
    },
    getLabel: function () {
      return function (i) {
        const choice = this.choices[i]
        if (!this.labels) {
          return choice
        } else {
          const pair = this.labels.filter(p => p[0] === choice)[0]
          return pair[1]
        }
      }
    }
  }
}
</script>
