<template>
  <div class="hh-photos__grid">
    <a
      v-for="(image, i) in transformedImages"
      class="hh-photo__link w-inline-block"
      @click="$emit('image-click', i)" >
      <img :src="image" class="hh-photos__image photo-fit" />
    </a>
  </div>
</template>

<script>
import { imageUrl } from '@/utils/vendor/cloudinary'
export default {
  name: 'Images',
  props: ['images'],
  computed: {
    transformedImages () {
      return this.images.map(url => imageUrl(url, { height: 200 }))
    }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.hh-photos__grid {
  position: relative;
  display: flex;
  margin: 20px -12px -2px -2px;
  flex-direction: row;
  justify-content: flex-start;
  flex-wrap: wrap;
  align-items: flex-start;
}

.hh-photo__link {
  position: relative;
  overflow: hidden;
  width: 32%;
  margin: 2px;
  padding-top: 33%;
  background-color: #888;
}

.hh-photos__image {
  object-fit: cover;
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}

@media (max-width: 991px){
  .hh-photos__grid {
    margin-right: -17px;
    margin-bottom: 2px;
  }

}

@media (max-width: 767px){
  .hh-photos__grid {
    margin-right: -8px;
    justify-content: flex-start;
  }

  .hh-photo__link {
    overflow: hidden;
    width: 49%;
    padding-top: 50%;
  }

}

@media (max-width: 479px){
  .hh-photos__grid {
    margin-right: -8px;
  }

  .hh-photo__link {
    width: 48%;
  }

}
</style>
