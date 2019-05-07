<template>
  <div class="main-nav">
    <Alert v-if="alert" />
    <Modal />
    <div class="lp-container w-container">
      <div class="logo-wrapper">
        <router-link :to="{ name: logoRouterTarget }" class="w-inline-block">
          <img src="@/assets/kc-logo-landscape.svg" alt="" class="logo">
        </router-link>
      </div>
      <div class="actions-wrapper">
        <router-link v-if="currentUser" :to="{name: 'ProviderProfile', params: {id: currentUser.id}}">
          <AvatarImage
          v-if="currentUser"
          :person="currentUser"
          className="image" />
        </router-link>
        <a @click="toggleMenu" class="nav-menu-button button w-button">Menu</a></div>
      <div
      v-if="showMenu"
      v-on-clickaway="clickedAway"
      class="nav-links-expanded">
        <ul class="unordered-list-2 w-list-unstyled">
          <li v-if="isAuthenticated">
            <router-link :to="{name: 'Events'}" class="link-block w-inline-block">
              <div class="text-block">Find parents &amp; playdates</div>
            </router-link>
          </li>
          <li v-if="isAuthenticated">
            <a href="/profile/edit" class="link-block w-inline-block">
              <div class="text-block">Edit profile</div>
            </a>
          </li>
          <li>
            <router-link to="/faq" class="link-block w-inline-block">
              <div class="text-block">FAQ</div>
            </router-link>
          </li>
          <li v-if="isAuthenticated">
            <router-link to="/my-rsvps" class="link-block w-inline-block">
              <div class="text-block">Playdates you're attending</div>
            </router-link>
          </li>
          <li v-if="isAuthenticated">
            <router-link to="/my-events" class="link-block w-inline-block">
              <div class="text-block">Playdates you're hosting</div>
            </router-link>
          </li>
          <li v-if="isAuthenticated">
            <a @click.prevent="logout" href="" class="link-block w-inline-block">
              <div class="text-block">Logout</div>
            </a>
          </li>
          <li v-if="!isAuthenticated">
            <a href="/log-in" class="link-block w-inline-block">
              <div class="text-block">Log in</div>
            </a>
          </li>
          <li v-if="!isAuthenticated">
            <a href="/sign-up" class="link-block w-inline-block">
              <div class="text-block">Sign up</div>
            </a>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import { signOut } from '@/utils/api'
import { mixin as clickaway } from 'vue-clickaway'
import AvatarImage from '@/components/base/AvatarImage'
import Alert from '@/components/Alert.vue'
import Modal from '@/components/base/Modal'
import { mapGetters } from 'vuex'

export default {
  name: 'MainNav',
  components: { AvatarImage, Alert, Modal },
  mixins: [ clickaway ],
  props: ['user'],
  data () {
    return {
      showMenu: false,
      menuButtonText: 'Menu'
    }
  },
  methods: {
    toggleMenu: function () {
      this.showMenu = !this.showMenu
    },
    clickedAway: function () {
      this.showMenu = false
    },
    logout: function () {
      signOut().then(() => {
        this.$store.dispatch('establishUser', { JWT: null })
        this.$router.push({ name: 'Events' })
        this.showMenu = false
      })
    }
  },
  computed: {
    logoRouterTarget () {
      return this.isAuthenticated ? 'Events' : 'SplashPage'
    },
    ...mapGetters([ 'isAuthenticated', 'currentUser', 'alert' ])
  }
}
</script>

<style scoped>

.body {
  font-family: soleil, sans-serif;
  color: #333;
  font-size: 14px;
  line-height: 20px;
}

a {
  color: #000;
  text-decoration: none;
}

.text-block {
  width: 100%;
  color: #000;
  text-decoration: none;
}

.nav-menu-button:active {
  background-color: #fff !important;
  color: #000;
  border: 1px solid black;
}

.main-nav {
  position: relative;
  background-color: #fff;
  font-family: soleil, sans-serif;
  color: #333;
  font-size: 14px;
  line-height: 20px;
}

.lp-container {
  position: relative;
  flex-direction: row;
  display: flex;
  padding: 24px 32px;
  justify-content: space-between;
  align-items: center;
}

.actions-wrapper {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 100%;
  -webkit-box-pack: end;
  -webkit-justify-content: flex-end;
  -ms-flex-pack: end;
  justify-content: flex-end;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
}

.button {
  min-height: 40px;
  margin-left: 16px;
  border: 1px solid #c2c2c2;
  border-radius: 4px;
  background-color: #fff;
  color: #000;
  font-size: 12px;
  letter-spacing: 2px;
  text-transform: uppercase;
}

.button:hover {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .04)), to(rgba(0, 0, 0, .04)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .04), rgba(0, 0, 0, .04));
}

.button:active {
  border-color: #1f88e9;
  background-color: #1f88e9;
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
  color: #fff;
}

.image {
  max-height: 40px;
  max-width: 40px;
  min-height: 40px;
  min-width: 40px;
  border-radius: 50%;
}

.logo {
  max-width: 130px;
}

.body {
  background-color: #f5f5f5;
}

.nav-links-expanded {
  position: absolute;
  top: 88px;
  right: 32px;
  width: 320px;
  border-top: 1px solid #f4f4f4;
  background-color: #fff;
  box-shadow: 0 17px 30px 0 rgba(0, 0, 0, .04);
  z-index: 99999999;
}

.unordered-list-2 {
  margin-bottom: 8px;
  padding-left: 0px;
}

.link-block {
  font-weight: normal;
  width: 100%;
  padding: 14px 16px 14px 24px;
}

.link-block:hover {
  background-color: rgba(0, 0, 0, .04);
}

.temporary-spacer-between-navs {
  height: 30px;
}

@media (max-width: 767px) {
  .lp-container {
    padding: 16px 20px;
  }
  .nav-links-expanded {
    top: 72px;
    right: 0px;
    width: 100%;
  }
  .link-block {
    padding-top: 16px;
    padding-bottom: 16px;
  }
}

@media (max-width: 479px) {
  .lp-container {
    padding-top: 11px;
    padding-bottom: 11px;
  }
  .button {
    min-height: auto;
    margin-left: 10px;
    padding: 6px 10px;
  }
  .image {
    max-height: 34px;
    max-width: 34px;
    min-height: 34px;
    min-width: 34px;
  }
  .logo {
    max-width: 120px;
  }
  .nav-links-expanded {
    top: 56px;
  }
}

</style>
