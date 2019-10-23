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
<style lang="scss" scoped>
.flow {
  .checkbox-field-extra-space {
    display: block;
    margin-bottom: 8px;
    padding-left: 35px;
    border-radius: 4px;
    background-color: hsla(0, 0%, 100%, .7);
  }

  .checkbox-field-extra-space:active {
    background-color: #fff;
  }

  .checkbox-field-extra-space:focus {
    background-color: #fff;
  }
  .onb-form-checkbox-list {
    color: transparent;
  }
  .onb-checkbox-label {
    width: 100%;
    padding-top: 18px;
    padding-bottom: 18px;
    padding-left: 6px;
    color: #1d8ae7;
  }
  .active-checkbox {
    background-color: #fff !important;
  }
  .onb-checkbox {
    margin-top: 22px !important;
    padding-top: 0px;
    padding-bottom: 0px;
  }
}
</style>
