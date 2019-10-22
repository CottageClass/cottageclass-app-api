<template>
  <div class="w-form">
    <form class="onb-form-checkbox-list">
      <div
        v-for="(id, index) in ids"
        class="checkbox-field-extra-space"
        :class="{'active-checkbox': isChecked(index)}"
        @click="toggleSelected(id)"
        :key="'cb-' + _uid + '-' + index"
      >
        <input
          type="checkbox"
          :id="'cb-' + _uid + '-' + index"
          :name="index"
          class="onb-checkbox w-checkbox-input"
          :checked="isChecked(index)"
          :class="{ 'active-checkbox': isChecked(index) }">
        <label :for="index" class="onb-checkbox-label w-form-label">
          {{ labels[index][1] }}
        </label>
      </div>
    </form>
  </div>
</template>

<script>

export default {
// labels is an array of arrays [id, label]
// value is an array of ids
  name: 'Checkboxes',
  props: ['value', 'labels'],
  data: () => {
    return { state: null }
  },
  computed: {
    ids: function () {
      return this.labels.map(pair => pair[0])
    },
    isChecked: function () {
      return function (index) {
        return this.state && this.state.includes(this.ids[index])
      }
    }
  },
  methods: {
    toggleSelected: function (id) {
      if (!this.state) { return }
      if (this.state.includes(id)) {
        this.state = this.state.filter(item => item !== id)
      } else {
        this.state.push(id)
      }
    }
  },
  watch: {
    value: function () {
      // update the state if the props change, after a fetch or something
      this.state = this.value
    },
    state: function () {
      this.$emit('input', this.state)
    }
  },
  mounted: function () {
    this.state = this.value
  }
}
</script>

<style lang="scss" scoped>

.flow {
  .onb-checkbox-label {
    width: 100%;
    padding-top: 18px;
    padding-bottom: 18px;
    padding-left: 6px;
    color: #1d8ae7;
  }
  .checkbox-field {
    display: block;
  }
  .active-checkbox {
    background-color: #fff !important;
  }
  .onb-checkbox {
    margin-top: 22px !important;
    padding-top: 0px;
    padding-bottom: 0px;
  }

  .onb-checkbox {
      margin-top: 22px;
  }

  .onb-form-checkbox-list {
    color: transparent;
  }

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

  .radio-form-block, .onb-form-block-checkbox-list {
    width: 100%;
    margin-bottom: 32px;
  }

  .label-checkbox, .onb-checkbox-label {
    width: 100%;
    padding: 18px 16px 18px 6px;
    color: #fff;
  }
}

</style>
