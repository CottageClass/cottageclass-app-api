<template>
    <div
    class="fb-button w-inline-block"
    @click.prevent="authenticateFacebook"
    >
      <img src="@/assets/facebook-button-icon.svg" width="24" height="24" alt="">
      <div class="fb-button-text">Continue with Facebook</div>
    </div>
</template>

<script>
import { providerAuthentication } from '@/mixins'

export default {
  name: 'FacebookButotn',
  mixins: [ providerAuthentication ]
}
</script>

<style scoped>

</style>
