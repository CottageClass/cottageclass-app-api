<template>
  <div class="chat-input-wrapper">
    <div class="form-block-wrapper">
      <div class="form-block w-form">
        <form id="email-form" name="email-form" data-name="Email Form" class="form">
          <textarea
            @keyup.enter.exact.prevent="submitMessage"
            @keydown.enter.exact.prevent=""
            v-model="message"
            placeholder="Type a message" maxlength="5000"
            id="message"
            name="message"
            class="input-style w-input"
            ref="keyboard"
          />
          <input type="submit"
                 @click.prevent="submitMessage"
                 class="submit-button w-button"
                 value="Send"
          />
        </form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'MessageSendBox',
  props: { value: { default: null }, openKeyboard: { default: false } },
  data () {
    return { message: null }
  },
  mounted () {
    if (this.openKeyboard) {
      this.$refs.keyboard.focus()
    }
  },
  watch: {
    value: {
      handler () {
        this.message = this.value
      }
    },
    message: {
      handler () {
        this.$emit('input', this.message)
      }
    }
  },
  methods: {
    submitMessage () {
      if (this.message) {
        this.$emit('message-submitted', { message: this.message })
      }
    }
  }
}
</script>

<style scoped lang="scss">
.chat-input-wrapper {
  background-color: #fff;
  position: fixed;
  left: 0%;
  top: auto;
  right: 0%;
  bottom: 0;
  display: flex;
  width: 100%;
  margin-bottom: 0;
  padding-right: 16px;
  padding-bottom: 0;
  padding-left: 16px;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.submit-button {
  position: absolute;
  left: auto;
  top: 12px;
  right: 8px;
  bottom: auto;
  padding-top: 8px;
  padding-bottom: 8px;
  border-radius: 4px;
  background-color: #fd7077;
}

.form {
  position: relative;
  display: flex;
  align-items: center;
}

.form-block {
  display: block;
  overflow: visible;
  width: 100%;
  max-width: 800px;
  margin-bottom: 0;
  padding-bottom: 12px;
  background-color: #fff;
}

.form-block-wrapper {
  display: flex;
  width: 100%;
  max-width: 800px;
  min-height: 64px;
  padding-right: 0;
  padding-left: 0;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background-color: #53bdb4;
}

.input-style {
  min-height: 64px;
  margin-bottom: 0;
  padding-right: 87px;
  border-style: solid;
  border-width: 1px;
  border-color: #d8d8d8;
  border-radius: 4px;
  font-size: 16px;
}

.input-style:focus {
  border-color: silver;
}

@media (max-width: 991px){
.form-block-wrapper {
  max-width: 664px
}
}
</style>
