<template>
    <img
      :src="`https://storage.googleapis.com/cottageclass-prod/images/${imageName}.jpg`"
      :srcset="`https://storage.googleapis.com/cottageclass-prod/images/${imageName}-p-500.jpg 500w,
      https://storage.googleapis.com/cottageclass-prod/images/${imageName}-p-800.jpg 800w,
      https://storage.googleapis.com/cottageclass-prod/images/${imageName}.jpg 908w`"
      sizes="(max-width: 479px) 100vw, (max-width: 991px) 29vw, 31vw">
</template>

<script>
export default {
  name: 'GridImage',
  props: ['imageName']
}
</script>

<style>

</style>
