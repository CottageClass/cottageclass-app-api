<template>
  <div class="navigation__logo-wrapper">
    <a @click="goToLink"
       class="navigation__logo-block w-inline-block"
       :class="isAuthenticated? 'logged-in' : 'logged-out'"
    >
      <img src="@/assets/lilypad__primary-transparent--cropped.svg" alt="" class="navigation__logo" />
    </a>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  name: 'MainNavLogo',
  computed: mapGetters(['isAuthenticated']),
  methods: {
    goToLink () {
      if (this.isAuthenticated) {
        this.$router.push({ name: 'Search' })
      } else {
        this.$router.push({ name: 'SplashPage' })
      }
    }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.navigation__logo {
  max-width: 130px;
  min-width: 130px;
}

@media (max-width: 767px){
  .navigation__logo {
    overflow: visible;
    max-width: 120px;
    min-width: 120px;
    margin-top: 0;
  }

}

@media (max-width: 479px){
  .navigation__logo-block.logged-in {
    overflow: hidden;
    width: 35px;
  }

  .navigation__logo {
    max-width: 120px;
  }

}
</style>
