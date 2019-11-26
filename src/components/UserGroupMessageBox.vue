<template>
  <div class="link-block-3">
    <AvatarImage
      :person="currentUser"
      :imageSize="48"
      class="home-item--photo photo-fit" />
    <div class="dummy-text-input"
         @click="processClick"
    >
      Share an idea...
    </div>
  </div>
</template>

<script>
import { postComment } from '@/utils/api'
import { mapGetters } from 'vuex'
import AvatarImage from '@/components/base/AvatarImage'

export default {
  name: 'UserGroupMessageBox',
  props: {
    groupId: { required: true, type: Number },
    allowTextEntry: { default: true }
  },
  data () {
    return {
      content: null
    }
  },
  components: { AvatarImage },
  computed: mapGetters(['currentUser']),
  methods: {
    processClick () {
      this.$router.push({ name: 'GroupChatPage', params: { groupId: this.groupId } })
    },
    async submitMessage () {
      if (!this.content) { return }
      try {
        const res = await postComment(this.groupId, this.content)
        this.$emit('message-submitted', res)
        this.content = null
      } catch (e) {
        this.showAlert('There was an error submitting your chat.  Try again later', 'failure')
      }
    }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.link-block-3 {
  display: flex;
  align-items: center;
}

.home-item--photo {
  width: 48px;
  height: 48px;
  min-height: 48px;
  min-width: 48px;
  border-radius: 8px;
}

.home-item--photo.photo-fit {
  width: 48px;
  height: 48px;
  min-height: 48px;
  min-width: 48px;
}

.dummy-text-input {
  &:focus, &::selection {
    outline: 0;
  }
  cursor: text;
  line-height: 48px;
  padding-left: 16px;
  color: gray;
  font-size: 16px;
  font-weight: 400;
  width: 100%;
  min-height: 48px;
  max-height: 48px;
  margin-left: 16px;
  border-style: solid;
  border-width: 1px;
  border-color: #d9d9d9;
  border-radius: 1000px;
}

@media (max-width: 767px){
  .home-item--photo {
    width: 36px;
    height: 36px;
    min-height: 36px;
    min-width: 36px;
  }

  .home-item--photo.photo-fit {
    width: 36px;
    height: 36px;
    min-height: 36px;
    min-width: 36px;
  }

  .dummy-text-input {
    font-size: 14px;
    min-height: 36px;
  }

}
</style>
