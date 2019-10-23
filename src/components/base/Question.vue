<template>
  <div class="question-content">
    <div class="title-container">
      <h1 class="question-title">{{ title }}</h1>
      <p class="onb-paragraph-subheading-2">{{ subtitle }}</p>
    </div>
    <div class="location-search-container">
      <slot></slot>
    </div>
    <p class="paragraph-small-50">{{ explanation }}</p>
  </div>
</template>

<script>
export default {
  name: 'Question',
  props: ['title', 'explanation', 'subtitle']
}
</script>

<style lang="scss" scoped>
  .onb-paragraph-subheading-2 {
    margin-bottom: 8px;
    color: #fff;
    font-size: 13px;
    line-height: 21px;
    text-align: center;
  }
  .question-title {
    font-size: 20px;
    color: #fff;
    text-align: center;
    font-weight: bold;
    line-height: 34px;
    margin-top: 0;
  }

  .title-container {
    margin-bottom: 32px;
    color: #fff;
  }

  @media (max-width: 479px) {
    .title-bar {
      align-items: center;
    }
  }
</style>
