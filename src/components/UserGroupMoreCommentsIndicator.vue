<template>
  <router-link
    :to="{name:'GroupChatPage', params:{groupId }}"
    class="comments--more"
  >
    {{ count }} more comments
  </router-link>
</template>

<script>
export default {
  name: 'UserGroupMoreCommentsIndicator',
  props: {
    count: { required: true, type: Number },
    groupId: { required: true }
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
