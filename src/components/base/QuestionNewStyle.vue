<template>
  <div class="content-container__new-style">
    <div class="title-container__new-style">
      <h1 class="question-title__new-style">{{ title }}</h1>
      <p class="onb-paragraph-subheading-2__new-style">{{ subtitle }}</p>
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
