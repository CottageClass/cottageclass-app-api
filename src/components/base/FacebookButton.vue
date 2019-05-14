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
.fb-button {
  display: flex;
  flex-direction: row;
  width: 100%;
  padding: 12px 24px 12px 16px;
  justify-content: center;
  align-items: center;
  border-radius: 4px;
  background-color: #3b5998;
  color: #fff;
  text-decoration: none;
  cursor: pointer;
}

.fb-button:active {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .15)), to(rgba(0, 0, 0, .15)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .15), rgba(0, 0, 0, .15));
}

.fb-button-text {
  margin-top: 1px;
  margin-left: 12px;
  font-size: 14px;
  text-align: left;
  letter-spacing: 0.4px;
  text-decoration: none;
}

@media (max-width: 479px) {
  .fb-button:active {
    background-color: #3b5998;
  }

  .fb-button-text {
    font-weight: 400;
  }
}
</style>
