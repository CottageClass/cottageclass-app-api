<template>
  <router-link
    :to="{name:'GroupChatPage', params:{ groupId }}"
    class="comments--more"
  >
    {{ prevCommentsText }}
  </router-link>
</template>

<script>
export default {
  name: 'UserGroupMoreCommentsIndicator',
  props: {
    count: { required: true, type: Number },
    groupId: { required: true }
  },
  computed: {
    prevCommentsText () {
      if (this.count === 1) {
        return `${this.count} previous comment`
      } else {
        return `${this.count} previous comments`
      }
    }
  }
}
</script>

<style scoped lang="scss">
.comments--more {
  cursor: pointer;
  color: #000;
  text-decoration: none;
  display: inline-block;
  margin-bottom: 16px;
  color: #1f88e9;
  &:hover {
    text-decoration: underline;
  }
}
</style>
