<template>
  <div>
  <transition name="slide">
      <div v-show="showAlert"
           :class="['alert-container', 'alert-' + alert.status,  state].join(' ')"
           ref="alertRef">
        <span v-html="alert.message" />
      </div>
  </transition>
  <transition name="grow">
      <div v-if="showPlaceholder"
           class="alert-placeholder"
           :class="state"
           ref="placeholderRef">
        <span>
        </span>
      </div>
  </transition>
  </div>
</template>

<script>
export default {
  name: 'PureAlert',
  props: ['alert'],
  data () {
    return {
      state: 'preload'
    }
  },
  computed: {
    showPlaceholder () {
      return this.state !== 'setup'
    },
    showAlert () {
      return this.state !== 'setup'
    }
  },
  methods: {
    setPlaceholderHeight () {
      const sheet = document.createElement('style')
      sheet.innerHTML = '.alert-placeholder { height: ' + this.$refs.alertRef.offsetHeight + 'px' + ' ;}'
      document.body.appendChild(sheet)
      this.state = 'setup'
      this.$nextTick(() => {
        this.state = 'go'
        console.log(this.state)
      })
    }
  },
  mounted () {
    this.setPlaceholderHeight()
  }
}

</script>

<style scoped lang="scss">

.slide-leave-active, .slide-enter-active {
  transition: transform 0.5s;
}
.slide-enter, .slide-leave-to {
  transform: translate(0, -100%);
}

.grow-leave-active, .grow-enter-active {
  transition: height 0.5s;
}
.grow-enter, .grow-leave-to {
  height: 0;
}
.alert-placeholder {
-webkit-backface-visibility: hidden;
}
.alert-container.setup, .alert-container.preload {
  transform: translate(0, -100%);
}
.alert-container {
  position: fixed;
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
