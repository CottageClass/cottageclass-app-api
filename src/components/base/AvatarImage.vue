<template>
  <img :src="url" :class="className" />
</template>

<script>
import { avatarUrl } from '@/utils/cloudinary'
import placeholder from '@/assets/avatar-placeholder.png'
import { screen } from '@/mixins'

export default {
  name: 'AvatarImage',
  props: ['person', 'className', 'imageSize'],
  mixins: [screen],
  computed: {
    physicalSize () {
      if (this.isRetina) {
        return 2 * parseInt(this.imageSize)
      }
      return parseInt(this.imageSize)
    },
    url: function () {
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
