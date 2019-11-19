<template>
  <div>
    <transition name="slide">
      <div v-if="show"
           class="alert-container"
           :class="`alert-${alertData.status} ${state}${accomodateNotch ? ' accomodateNotch' : ''}${accomodateStatusBar ? ' accomodateStatusBar' : ''}`"
           ref="alertRef">
        <span v-html="alertData.message" />
      </div>
    </transition>
    <transition name="grow">
      <div v-if="show"
           class="alert-placeholder"
           :class="state">
        <span>
        </span>
      </div>
    </transition>
  </div>
</template>

<script>
import { platform } from '@/mixins'

export default {
  name: 'PureAlert',
  mixins: [platform],
  props: ['alert'],
  data () {
    return {
      state: 'calculation',
      alertData: null
    }
  },
  computed: {
    show () {
      return (this.state === 'go' || this.state === 'calculation') && this.alertData
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
      })
    }
  },
  watch: {
    alert () {
      if (!this.alert) {
        this.state = 'hiding'
      } else {
        this.alertData = this.alert
        this.state = 'calculation'
        this.$nextTick(() => {
          this.setPlaceholderHeight()
        })
      }
    }
  },
  mounted () {
    if (this.alertData) {
      this.setPlaceholderHeight()
    }
  },
  created () {
    this.alertData = this.alert
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
.alert-container.setup {
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
  &.accomodateNotch {
    padding-top: 35px;
  }
  &.accomodateStatusBar {
    padding-top: 18px;
  }
  &.alert-success {
    background-color: #c1ffda;
    color: rgb(12, 186, 82);
  }
  &.alert-failure {
    background-color: #ffbebe;
    color: #c73200;
  }
}

@media (max-width: 479px) {
  .alert-success a {
    display: inline;
    font-weight: bold;
    color: inherit;
  }
}
</style>
