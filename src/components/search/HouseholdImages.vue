<template>
  <div class="household-container">
    <img v-for="imageUrl of displayImageUrls"
         :src="imageUrl" width="24" height="24"
         alt="" class="tiny-photo" />
    <div class="more-images-label">{{moreText}}</div>
  </div>
</template>

<script>

import { householdImageUrl } from '@/utils/cloudinary'

export default {
  name: 'HouseholdImages',
  props: { user: { required: true } },
  mixins: [],
  data () {
    return {
    }
  },
  computed: {
    moreText () {
      if (this.user.images.length > 3) {
        return (this.user.images.length - 3) + ' more'
      }
      return ''
    },
    displayImageUrls () {
      return this.user.images.slice(0, 3).map(url => {
        return householdImageUrl(url, 24)
      })
    }
  },
  mounted () {
  }
}
</script>

<style scoped>
.tiny-photo {
  max-height: 24px;
  max-width: 24px;
  min-height: 24px;
  min-width: 24px;
  margin-right: 6px;
}

.household-container {
  display: flex;
  margin-top: 8px;
  align-items: center;
}

</style>
