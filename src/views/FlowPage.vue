<template>
  <div class="page-container flow">
    <div class="column-container">
      <Nav :button="button"
           :hidePrevious="hidePrevious"
           @next="nextClick"
           @prev="prevButtonHandler"
      />
      <ErrorMessage v-if="errorMessage && showErrorMessage"
                    :text="errorMessage" />
      <router-view class="content-container"
                   @setNavProps="setNavProps"
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
      prevButtonHandler: () => {},
      nextButtonHandler: () => {},
      hidePrevious: false,
      button: 'next'
    }
  },
  methods: {
    nextClick () {
      this.nextButtonHandler()
      this.showErrorMessage = !!this.errorMessage
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
    .content-container {
      width: 670px;
    }
  }

  @media (max-width: 767px) {
    .content-container {
      width: 100%;
      margin-top: 0px;
      margin-bottom: 0px;
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
