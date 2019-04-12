<template>
  <div class="pin-wrapper">
    <div class="pin-div">
      <img class="avatar" :src="avatarUrl">
    </div>
  </div>
</template>

<script>
export default {
  name: 'UserPinMapMarker',
  props: [ 'avatarUrl' ]
}
</script>

<style scoped>
.pin-wrapper {
  position: relative;
  display: inline-block;
  cursor: pointer;
}
.pin-div {
  position: absolute;
  left: -18px;
  top: -53px;
  background-image: url('../../assets/pin-blue.svg');
  background-size: cover;
  background-repeat:no-repeat;
  width: 36px;
  height: 58px;
}
.avatar {
  position: absolute;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  top: 2px;
  left: 2px;
}
</style>
