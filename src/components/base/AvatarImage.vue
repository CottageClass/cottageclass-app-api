<template>
  <img :src="url"
       :class="className"
       class="avatar-image"/>
</template>

<script>
import { avatarUrl } from '@/utils/vendor/cloudinary'
import placeholder from '@/assets/avatar-placeholder.png'
import { screen } from '@/mixins'

export default {
  name: 'AvatarImage',
  props: ['person', 'event', 'className', 'imageSize'],
  mixins: [screen],
  computed: {
    physicalSize () {
      if (this.isRetina) {
        return 2 * parseInt(this.imageSize)
      }
      return parseInt(this.imageSize)
    },
    url: function () {
      if (this.event) {
        if (this.event.images.length > 0) {
          return avatarUrl(this.event.images[0], this.physicalSize)
        }
      }
      if (this.person) {
        if (this.person.avatar) {
          return avatarUrl(this.person.avatar, this.physicalSize)
        } else if (this.person.facebookUid) {
          return 'https://graph.facebook.com/' + this.person.facebookUid + `/picture?width=${this.physicalSize}`
        } else {
          return placeholder
        }
      } else {
        return placeholder
      }
    }
  }
}
</script>
<style scoped>
.avatar-image {
  object-fit: cover;
}

</style>
