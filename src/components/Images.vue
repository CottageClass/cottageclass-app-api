<template>
  <div class="mask">
    <div class="scrolling-wrapper">
      <div class="carousel-image-container" v-for="image in transformedImages">
        <img :src="image">
      </div>
    </div>
  </div>
</template>

<script>
import { imageUrl } from '@/utils/cloudinary'
export default {
  name: 'Images',
  props: ['images'],
  computed: {
    transformedImages () {
      return this.images.map(url => imageUrl(url, { height: 111 }))
    }
  }
}
</script>

<style scoped>

.mask {
  height: 123px;
  overflow: hidden;
  width: 100%;
}
.scrolling-wrapper {
  overflow-x: scroll;
  overflow-y: hidden;
  display: flex;
  flex-wrap: nowrap;
  align-items: center;
  background-color: #fff;
  -webkit-overflow-scrolling: touch;

  padding-bottom: 20px;
  padding-top: 6px;
  box-sizing: content-box;
}

.carousel-image-container {
  flex-shrink: 0;
  width: 111px;
  height: 111px;
  margin-right: 6px;
  background-color: #fff;
}

.carousel-image-container img {
  width: 111px;
  height: 111px;
  object-fit: cover;
  width: auto;
  height: 100%;
  background-color: #fff;
}

</style>
