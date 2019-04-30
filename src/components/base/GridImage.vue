<template>
    <img
      :src="`https://storage.googleapis.com/cottageclass-prod/images/${imageName}-p-500.jpg`"
      :srcset="`https://storage.googleapis.com/cottageclass-prod/images/${imageName}-p-200.jpg 200w,
                https://storage.googleapis.com/cottageclass-prod/images/${imageName}-p-500.jpg 500w,
                https://storage.googleapis.com/cottageclass-prod/images/${imageName}-p-800.jpg 800w,
                https://storage.googleapis.com/cottageclass-prod/images/${imageName}-p-1200.jpg 1200w`"
      sizes="(max-width: 479px) 47vw, 31vw">
</template>

<script>
export default {
  name: 'GridImage',
  props: ['imageName']
}
</script>

<style>

</style>
