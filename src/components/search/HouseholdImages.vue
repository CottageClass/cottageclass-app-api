<template>
  <div class="household-photos-tiny--container">
    <img v-for="imageUrl of displayImageUrls"
         :src="imageUrl" width="24" height="24"
         alt="" class="household-photos-tiny__photo photo-fit" />
    <div class="other-events-card__attendees--more">12 more</div>
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

</style>
