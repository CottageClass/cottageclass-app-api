<template>
  <Question
    title="Your profile picture"
    subtitle="To build a safe and uplifting space, we ask everyone to provide a profile picture, if possible a simple picture of you!">
    <div class="auth-wrapper">
      <div class="profile-photo-wrapper"
           @click="handlePhotoClick">
        <img v-if="previewAvatarUrl"
             :src="previewAvatarUrl"
             class="profile-photo"
             height="80"
             @load="avatarImageLoaded"
        >
        <img
          v-else
          src="@/assets/profile-photo-placeholder.svg"
          class="profile-photo"
        >
        <a class="button-3 avatar-upload-button" :class="{'invalid': avatarLoading || errors.has('avatar') }">
          <span v-if="avatarLoading">Uploading...</span>
          <span v-else-if="!avatar">Add profile photo</span>
          <span v-else>Replace photo</span>
        </a>
      </div>
    </div>
  </Question>
</template>

<script>

import Question from '@/components/base/Question.vue'
import { createWidget, avatarUrl } from '@/utils/vendor/cloudinary'

export default {
  name: 'AvatarUpload',
  props: ['value'],
  components: { Question },
  data () {
    return {
      avatar: this.value.avatar,
      avatarLoading: false,
      cloudinaryUploadWidget: null,
      errorMesg: 'Please submit an avatar image.',
      previewAvatarUrl: null
    }
  },
  created () {
    this.cloudinaryUploadWidget = createWidget(this.cloudinaryEventHandler, {
      croppingAspectRatio: 1,
      multiple: false
    })
    if (this.avatar) {
      this.previewAvatarUrl = avatarUrl(this.avatar, 80)
    }
  },
  computed: {
    err: function () {
      if (this.avatar) {
        return false
      } else {
        return this.errorMesg
      }
    }
  },
  methods: {
    cloudinaryEventHandler (error, result) {
      if (!error && result && result.event === 'abort') {
        this.avatarLoading = false
      }
      if (!error && result && result.event === 'success') {
        let transformation = ''
        if (result.info.coordinates.custom) {
          transformation = 'c_thumb,g_custom/'
        }
        this.avatar = 'https://res.cloudinary.com/' + process.env.CLOUDINARY_CLOUD_NAME + '/image/upload/' + transformation + result.info.path
        this.previewAvatarUrl = avatarUrl(this.avatar, 80)
        this.disableForm = false
      }
    },
    handlePhotoClick () {
      this.avatarLoading = true
      this.disableForm = true
      this.cloudinaryUploadWidget.open()
    },
    avatarImageLoaded () {
      this.avatarLoading = false
    }
  },
  watch: {
    avatar: {
      handler: function () {
        this.$emit('input', { avatar: this.avatar, err: this.err })
      },
      immediate: true
    }
  }
}
</script>
<style lang="scss" scoped>
.flow {
  .profile-photo {
    margin-bottom: 16px;
    border-radius: 50%;
  }

  .avatar-upload-button {
    background-color: white;
    padding: 10px 50px;
  }

  .button-3 {
    border-style: solid;
    border-width: 1px;
    border-color: rgba(0, 0, 0, .15);
    border-radius: 4px;
    background-color: #fff;
    color: #000;
  }

  .auth-wrapper {
    display: flex;
    margin-left: auto;
    margin-right: auto;
    width: 300px;
    box-sizing: content;
    flex-direction: column;
    align-items: center;
  }

  .profile-photo-wrapper {
    width: 100%;
    background-color: #fff;
    display: flex;
    margin-bottom: 10px;
    padding: 16px;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    border-style: solid;
    border-width: 1px;
    border-color: rgba(0, 0, 0, .15);
    border-radius: 4px;
  }
}
</style>
