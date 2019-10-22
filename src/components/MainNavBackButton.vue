<template>
  <div>
    <a @click="goBack"
       class="navigation__back-block w-inline-block"
       :class="{'logged-in': isAuthenticated}">
      <img src="@/assets/baseline-arrow_back-24px.svg" alt="" class="back_button" />
    </a>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  name: 'MainNavBackButton',
  computed: mapGetters(['isAuthenticated']),
  methods: {
    goBack () {
      this.$router.go(-1)
    }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.back_button {
  width: 32px;
  height: 32px;
}
</style>
