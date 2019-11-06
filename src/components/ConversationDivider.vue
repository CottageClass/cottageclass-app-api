<template>
  <div>
    <div class="chat-detail--day">
      <div class="divider"></div>
      <div class="text-white-background">
        <div class="chat-detail--day-text">{{ dividerText }}</div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'ConversationDivider',
  props: { dividerText: String }
}
</script>

<style scoped lang="scss">
.chat-detail--day {
  position: relative;
  display: flex;
  padding-bottom: 12px;
  flex-direction: column;
  align-items: center;
  background-color: #fff;
}

.chat-detail--day-text {
  position: static;
  top: 108px;
  width: 100%;
  background-color: transparent;
  color: #b3b3b3;
  text-align: center;
}

.divider {
  position: absolute;
  left: 0%;
  top: 10px;
  right: 0%;
  bottom: auto;
  z-index: 0;
  width: 100%;
  height: 1px;
  min-height: 1px;
  background-color: rgba(0, 0, 0, 0.06);
}

.text-white-background {
  position: relative;
  z-index: 0;
  padding-right: 8px;
  padding-left: 8px;
  flex: 0 auto;
  background-color: #fff;
}
</style>
