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
    min-height: 100vh;
  }

  .column-container {
    background-color: #0d73c7;
    margin-right: auto;
    margin-left: auto;
    display: flex;
    flex-direction: column;
    align-items: center;
    min-height: 100vh;
    width: 100%;
  }

  .content-container {
    flex: 1;
    width: 720px;
    margin-bottom: 0px;
    padding: 32px 32px 72px;
    background-color: #1c8be7;
  }

  @media (max-width: 991px) {
    .column-container {
      width: auto;
      margin-right: 32px;
      margin-left: 32px;
    }

  }

  @media (max-width: 767px) {

    .column-container {
    position: relative;
    top: -97px;
    width: auto;
    margin-right: 0px;
    margin-left: 0px;
    border-radius: 0px;
    box-shadow: none;
    }

    .content-container {
    margin-top: 99px;
    }
  }

  @media (max-width: 479px) {
    .column-container {
      margin-top: 28px;
    }
    .content-container {
      margin-top: 70px;
    }
  }
</style>

<style lang="scss">
  .flow textarea {
    padding-top: 8px;
    padding-bottom: 16px;
    padding-left: 18px;
    border-style: solid;
    border-width: 1px;
    border-color: #e4e4e4;
    border-radius: 4px;
    background-color: #f0f0f0;
    font-size: 16px;

    &.text-area-decribe-need {
      height: 200px;
    }

    &:active {
      background-color: #fff;
    }
    &:focus {
      background-color: #fff;
      border-color: #0dba52;
    }

    &::placeholder {
      color: rgba(0, 0, 0, .3);
    }
  }

</style>
