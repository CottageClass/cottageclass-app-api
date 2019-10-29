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

<style lang="scss" scoped src="@/assets/style/scss/flow.scss"></style>

<style lang="scss" scoped>
.flow {
  .location-search-container{
    padding-right: 32px;
    padding-left: 32px;
  }
  .question-title {
    font-size: 24px;
    color:#333;
    text-align: center;
    font-weight: bold;
    line-height: 34px;
    margin-top: 0;
    margin-bottom: 10px;
  }

  .title-container {
    margin-bottom: 0px;
    padding: 32px;
    color: #fff;
  }

  .paragraph-small-50 {
  margin-bottom: 8px;
  color: #9c9c9c;
  font-size: 11px;
  line-height: 19px;
  text-align: center;
  letter-spacing: .2px;
  }

  @media (max-width: 479px) {
    .location-search-container{
      padding-right: 16px;
      padding-left: 16px;
    }
    .title-container {
    padding-right: 16px;
    padding-left: 16px;
    }
    .title-bar {
      align-items: center;
    }
  }
}

.editing {
  .location-search-container{
    width: 100%;
  }
  .question-title {
    font-size: 17px;
  }
  .question-content {
    display: flex;
    flex-wrap: wrap;
    width: 100%;
    margin-top: 16px;
    padding: 0 32px 40px 32px;
    flex-direction: row;
    justify-content: flex-start;
    align-items: flex-start;
    border-radius: 4px;
    background-color: #fff;
    box-shadow: 0 1px 2px 0 rgba(0, 0, 0, .08);
  }
}
</style>
