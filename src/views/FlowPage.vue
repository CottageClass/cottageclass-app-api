<template>
  <div class="page-container">
    <Nav :button="button"
         :hidePrevious="hidePrevious"
         @next="nextButotnHandler"
         @prev="prevButotnHandler"
    />
    <router-view class="content-container flow"
                 @setNavProps="setNavProps"
    />
  </div>
</template>

<script>
import Nav from '@/components/FTE/Nav'

export default {
  name: 'FlowPage',
  components: { Nav },
  data () {
    return {
      prevButotnHandler: () => {},
      nextButotnHandler: () => {},
      hidePrevious: false,
      button: 'next'
    }
  },
  methods: {
    setNavProps (e) {
      Object.assign(this, e)
    }
  }
}
</script>

<style scoped lang="scss">
  .page-container {
    display: flex;
    flex-direction: column;
    background-color: #0d73c7;
    min-height: 100vh;
  }

  .content-container {
    flex: 1;
    width: 720px;
    margin-right: auto;
    margin-left: auto;
    background-color: #1c8be7;
    margin-bottom: 0px;
    padding: 32px 32px 72px;
    min-height: 100%;
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
