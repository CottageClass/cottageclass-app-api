<template>
  <div class="form-describe-need w-form">
    <form v-on:submit.prevent id="email-form-2">
      <textarea
        v-model="text"
        id="field"
        @input="$emit('input', text)"
        name="field"
        :placeholder="placeholder"
        :maxlength="maxLength || 5000"
        class="w-input"
        :rows="rows"
      >
      </textarea>
    </form>
  </div>
</template>
<script>
export default {
  name: 'FormWithTextArea',
  props: {
    value: {},
    placeholder: {},
    maxLength: {},
    rows: {
      default: 2
    }
  },
  data () {
    return {
      text: this.value
    }
  }
}
</script>

<style lang="scss" scoped src="@/assets/style/scss/editing.scss"></style>
<style lang="scss" scoped>
.flow {
  .tall textarea {
    height: 200px;
  }

  .short textarea {
    height: 75px;
  }
}
</style>
