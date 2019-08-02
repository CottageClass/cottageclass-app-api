<template>
  <div class="onb-error-container">
    <div class="onb-error-text">
      <span v-if="text" v-html="text"></span>
      <ul v-if="messages">
        <li v-for="message in messages"
            v-html="message" />
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  props: ['text', 'messages'],
  name: 'ErrorMessage'
}
</script>
