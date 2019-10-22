<template>
  <div class="onb-body">
    <Nav :button="button"
         :hidePrevious="hidePrevious"
         @next="nextButotnHandler"
    />
    <router-view class="content-container"
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
  .onb-body {
    background-color: #0d73c7;
  }
  .content-container {
    width: 720px;
    min-height: 100vh;
    margin-right: auto;
    margin-left: auto;
    background-color: #1c8be7;
    margin-bottom: 0px;
    padding: 32px 32px 72px;
  }
</style>
