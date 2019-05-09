<template>
  <transition name="slide">
      <div v-if="alert" :class="'alert-container alert-' + alert.status" >
        <span v-html="alert.message" />
      </div>
  </transition>
</template>

<script>
export default {
  name: 'PureAlert',
  props: ['alert']
}
</script>

<style scoped lang="scss">

.slide-leave-active, .slide-enter-active {
  transition: 0.5s;
}
.slide-enter, .slide-leave-to {
  transform: translate(0, -100%);
}
.alert-container {
  position: fixed;
}
.alert-container-flow-placeholder {
}

.alert-container-flow-placeholder, .alert-container {
  top:0;
  width: 100%;
  margin-bottom: 16px;
  padding: 10px 10px 10px;
  text-align: center;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  z-index: 999;  // this is less than the modal index
}

.alert-success {
  background-color: #c1ffda;
  color: rgb(12, 186, 82);
}

.alert-failure {
  background-color: #ffbebe;
  color: #c73200;
}

@media (max-width: 479px) {
  .alert-success a {
    display: inline;
    font-weight: bold;
    color: inherit;
  }
}
</style>
