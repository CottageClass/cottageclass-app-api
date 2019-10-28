<template>
  <div class="page-container flow">
    <div class="column-container">
      <Nav :button="button"
           :hidePrevious="hidePrevious"
           @next="nextClick"
           @prev="prevClick"
      />
      <ErrorMessage v-if="errorMessage && showErrorMessage"
                    :text="errorMessage" />
      <router-view class="content-container"
                   @set-nav-props="setNavProps"
      />
    </div>
  </div>
</template>

<script>
import Nav from '@/components/FTE/Nav'
import ErrorMessage from '@/components/base/ErrorMessage.vue'

export default {
  name: 'FlowPage',
  components: { Nav, ErrorMessage },
  data () {
    return {
      errorMessage: null,
      showErrorMessage: false,
      prevButtonHandler: null,
      nextButtonHandler: null,
      hidePrevious: false,
      button: 'next'
    }
  },
  methods: {
    prevClick () {
      if (this.prevButtonHandler) {
        this.prevButtonHandler()
      } else {
        this.$router.go(-1)
      }
    },
    nextClick () {
      if (this.errorMessage) {
        this.showErrorMessage = true
      } else {
        this.showErrorMessage = !!this.errorMessage
        this.nextButtonHandler && this.nextButtonHandler()
      }
    },
    setNavProps (e) {
      Object.assign(this, e)
      if (this.errorMessage) {
        // reset showErrorMessage if all errors have been cleared
        this.showErrorMessage = false
      }
    }
  }
}
</script>

<style scoped lang="scss">
  .page-container {
    height: 100%;
    background-color: #fc6f77;
  }

  .column-container {
  position: relative;
  left: 0%;
  top: 40px;
  right: 0%;
  bottom: auto;
  z-index: 1000;
  display: flex;
  width: 876px;
  height: 100%;
  min-height: 500px;
  margin: 0 auto 100px;
  flex-direction: column;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: 1px 1px 35px 0 rgba(0, 0, 0, 0.2);
  }

  .content-container {
   width: 100%;
  }

  @media (max-width: 991px) {
    .column-container {
      width: auto;
      margin-right: 32px;
      margin-left: 32px;
    }

  }

  @media (max-width: 767px) {
    .content-container {
    margin-top: 99px;
    }

    .column-container {
    position: relative;
    top: -97px;
    width: auto;
    margin-right: 0px;
    margin-left: 0px;
    border-radius: 0px;
    box-shadow: none;
    }
  }

  @media (max-width: 479px) {
    .content-container {
      margin-top: 70px;
    }
    .column-container {
      margin-top: 28px;
    }
  }
</style>

<style lang="scss">
  .flow textarea {
    padding-top: 16px;
    padding-bottom: 16px;
    padding-left: 18px;
    border: 1px none #000;
    border-radius: 4px;
    background-color: hsla(0, 0%, 100%, .7);
    font-size: 16px;

    &.text-area-decribe-need {
      height: 200px;
    }

    &:active {
      background-color: #fff;
    }
    &:focus {
      background-color: #fff;
    }

    &::placeholder {
      color: rgba(0, 0, 0, .3);
    }
  }

</style>
