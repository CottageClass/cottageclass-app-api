<template>
  <span :class="{ uploadButtonActive: !disableUploadButton }">
    <label for="photoUploadInput">
      <slot></slot>
    </label>
    <input
    type="file"
    style="visibility:hidden;"
    id="photoUploadInput"
    name="photoUploadInput"
    v-on:change="upload"
    accept="image/*"
    >
  </span>
</template>
<script>
import { uploadImage } from '@/utils/cloudinary'

export default {
  name: 'ImageUploadToCloudinary',
  data () {
    return {
      disableUploadButton: false
    }
  },
  methods: {
    async upload (event) {
      this.$emit('startedUploading')
      this.disableForm = true
      try {
        this.avatar_url = await uploadImage(event.target.files[0])
        this.$emit('imageUpload', this.avatar_url)
      } catch (e) {
        this.logError(e)
      } finally {
        this.disableForm = false
      }
    }
  }
}
</script>
