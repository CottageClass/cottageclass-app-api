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

<style lang="scss" scoped>

.flow {
  .onb-error-text a.error-link {
    color: #c96168;
    text-decoration: underline;
  }

  .onb-error-container {
    width: 720px;
    display: flex;
    min-height: 60px;
    padding: 16px 16px 18px;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    background-color: #ffbebe;
    color: #c73200;
  }

  .onb-error-text {
    font-size: 13px;
  }

  @media (max-width: 991px) {
    .onb-error-container {
      width: 670px;
    }
  }
  @media (max-width: 767px) {
    .onb-error-container {
      width: 100%;
    }
  }
}
</style>
