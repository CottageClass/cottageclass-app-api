<template>
  <div class="onb-body">
    <Nav :button="button"
         :hidePrevious="hidePrevious"
         @next="nextButotnHandler"
    />
    <router-view class="content-wrapper"
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

<style scoped>

  .onb-body {
    background-color: #f6f6f6;
  }
</style>
