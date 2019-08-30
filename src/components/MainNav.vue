<template>
  <div class="main-nav">
    <Alert />
    <PureModal v-if="showNameChangeModal"
               :title="nameChangeModalOptions.title"
               :bodyText="nameChangeModalOptions.bodyText"
               :buttonNames="nameChangeModalOptions.buttonNames"
               @primaryClick="nameChangeModalOptions.closeCallback"
               @closeButtonClick="nameChangeModalOptions.closeCallback"
    />

    <div class="navigation__container w-container">
      <MainNavLogo />
      <LoggedOutNav v-if="!isAuthenticated" />
      <ul v-if="isAuthenticated" class="navigation__links-list w-list-unstyled">
        <li class="navigation__link-item">
          <router-link :to="{name: 'Search'}"
                       class="navigation__button w-inline-block"
                       :class="{'selected-nav-item': isSearchPage}"
          >
            <img src="@/assets/house.svg" alt="" class="navigation__icon" />
            <div class="navigation__button-label">Nearby Parents</div>
          </router-link>
        </li>
        <li class="navigation__link-item">
          <router-link :to="{name: 'YourPlaydates'}"
                       class="navigation__button w-inline-block"
                       :class="{'selected-nav-item': isYourPlaydatesPage}"
          >
            <img src="@/assets/calendar.svg" alt="" class="navigation__icon" />
            <div class="navigation__button-label">Your Playdates</div>
            <div v-if="false" class="global__badge TODO">
              <div class="badge__text">99+</div>
            </div>
          </router-link>
        </li>
      </ul>
      <div v-if="isAuthenticated" class="navigation__profile-menu__container">
        <a class="navigation__profile-menu-button w-inline-block"
           @click="toggleMenu"
        >
          <AvatarImage
            v-if="currentUser"
            :person="currentUser"
            className="image"
            imageSize="40"
          />
          <img src="@/assets/triangle-down_1triangle-down.png" alt="" class="navigation__down-triangle" />
        </a>
      </div>
      <ExpandingMenu v-if="showMenu"
                     v-on-clickaway="clickedAway"
      />
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { mixin as clickaway } from 'vue-clickaway'

import MainNavLogo from '@/components/MainNavLogo'
import AvatarImage from '@/components/base/AvatarImage'
import LoggedOutNav from '@/components/LoggedOutNav'
import Alert from '@/components/Alert.vue'
import PureModal from '@/components/base/PureModal'
import ExpandingMenu from '@/components/ExpandingMenu'

export default {
  name: 'MainNav',
  data () {
    return {
      showMenu: false,
      showNameChangeModal: false
    }
  },
  components: { AvatarImage, Alert, ExpandingMenu, LoggedOutNav, MainNavLogo, PureModal },
  mixins: [ clickaway ],
  computed: {
    nameChangeModalOptions () {
      return {
        title: `Our name is now Lilypad!`,
        bodyText: 'Hi! We just changed our name to Lilypad (and moved our site to JoinLilypad.com) but everything about the service, the people, and the organization behind it is exactly the same. We hope you love the new name (and lilypads) as much as we do!',
        buttonNames: ['Continue to JoinLilypad.com'],
        closeCallback: this.closeCallback
      }
    },
    isYourPlaydatesPage () {
      return this.$route.name === 'YourPlaydates'
    },
    isSearchPage () {
      return this.$route.name === 'Search'
    },
    ...mapGetters(['currentUser', 'isAuthenticated'])
  },
  methods: {
    toggleMenu: function () {
      this.showMenu = !this.showMenu
    },
    clickedAway: function () {
      this.showMenu = false
    },
    closeCallback () {
      this.showNameChangeModal = false
      this.$router.push({ query: {} })
    }
  },
  mounted () {
    if (this.$route.query && this.$route.query['welcome-to-the-new-lilypad']) {
      this.showNameChangeModal = true
    }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}
.main-nav {
  position: relative;
  background-color: #fff;
  font-family: soleil, sans-serif;
  color: #333;
  font-size: 14px;
  line-height: 20px;
}
.image {
  max-height: 40px;
  max-width: 40px;
  min-height: 40px;
  min-width: 40px;
  border-radius: 50%;
}

.navigation__container {
  position: relative;
  display: flex;
  padding: 16px 32px;
  justify-content: space-between;
  align-items: center;
}

.navigation__links-list {
  display: flex;
  width: 100%;
  margin: 0;
  padding-left: 0;
  justify-content: flex-end;
  align-items: center;
}

.navigation__link-item {
  position: relative;
  margin-right: 8px;
  margin-left: 8px;
}

.navigation__button {
  position: relative;
  display: flex;
  padding: 10px 12px;
  align-items: center;
  border-bottom: 1px solid transparent;
  border-radius: 4px;
}

.navigation__button:hover {
  background-color: rgba(0, 0, 0, 0.06);
}

.navigation__button-label {
  margin-left: 8px;
  font-size: 13px;
}

.navigation__profile-menu-button {
  position: static;
  display: flex;
  min-width: 69px;
  margin-left: 0;
  padding: 6px;
  justify-content: flex-end;
  align-items: center;
  border-radius: 4px;
}

.navigation__profile-menu-button:hover {
  background-color: rgba(0, 0, 0, 0.06);
}

.navigation__profiile-photo {
  max-height: 40px;
  max-width: 40px;
  min-height: 40px;
  min-width: 40px;
  border-radius: 50%;
}

.navigation__down-triangle {
  margin: 0 0 0 6px;
}

.navigation__profile-menu__container {
  position: relative;
  margin-left: 16px;
  justify-content: flex-end;
}

.navigation__icon {
  min-height: 24px;
  min-width: 24px;
}

.selected-nav-item {
  display: flex;
  padding: 10px 12px;
  align-items: center;
  border-bottom: 2px solid #333;
  border-top-left-radius: 4px;
  border-top-right-radius: 4px;
  border-radius: 0;
}

.global__badge {
  position: absolute;
  left: 0%;
  top: 0%;
  right: auto;
  bottom: auto;
  display: flex;
  min-height: 20px;
  min-width: 20px;
  justify-content: center;
  align-items: center;
  border-radius: 20px;
  background-color: #e82d55;
  box-shadow: 0 3px 4px 0 rgba(0, 0, 0, 0.4);
  opacity: 1;
}

.badge__text {
  padding: 0 6px;
  color: #fff;
  font-size: 10px;
  line-height: 11px;
  font-weight: 700;
  text-align: center;
}

@media (max-width: 991px){
  .navigation__button:hover {
    background-color: transparent;
  }

  .navigation__button:active {
    background-color: rgba(0, 0, 0, 0.06);
  }

  .navigation__profile-menu-button:hover {
    background-color: transparent;
  }

  .navigation__profile-menu-button:active {
    background-color: rgba(0, 0, 0, 0.06);
  }

  .selected-nav-item:hover {
    background-color: transparent;
  }

}

@media (max-width: 767px){
  .navigation__button-label {
    display: flex;
    flex: 0 0 auto;
  }

  .navigation__container {
    padding: 0 16px;
  }

  .navigation__link-item {
    margin-right: 4px;
    margin-left: 4px;
  }

  .navigation__button {
    padding-top: 16px;
    padding-bottom: 16px;
  }

  .navigation__profile-menu-button {
    overflow: visible;
    min-width: 44px;
    margin-right: 0;
    margin-left: 0;
    border-radius: 50px;
  }

  .navigation__profile-menu-button:hover {
    background-color: transparent;
  }

  .navigation__profile-menu-button:active {
    background-color: rgba(0, 0, 0, 0.06);
  }

  .navigation__profiile-photo {
    max-height: 32px;
    max-width: 32px;
    min-height: 32px;
    min-width: 32px;
  }

  .navigation__down-triangle {
    display: none;
  }

  .navigation__profile-menu__container {
    position: static;
    margin-right: -8px;
    margin-left: 8px;
  }

  .selected-nav-item {
    padding-top: 16px;
    padding-bottom: 16px;
  }

  .global__badge {
    top: 11px;
  }
}

@media (max-width: 479px){
  .image {
    max-height: 34px;
    max-width: 34px;
    min-height: 34px;
    min-width: 34px;
  }
  .navigation__container {
    padding-top: 0;
    padding-bottom: 0;
  }

  .navigation__link-item {
    margin-right: 0;
    margin-left: 0;
  }

  .navigation__button {
    flex-direction: column;
    border-radius: 0;
  }

  .navigation__button-label {
    margin-top: 2px;
    margin-left: 0;
    font-size: 10px;
    line-height: 10px;
    text-align: center;
  }

  .navigation__profile-menu-button {
    margin-left: 0;
  }

  .navigation__profile-menu__container {
    margin-left: 8px;
  }

  .selected-nav-item {
    padding-top: 16px;
    padding-bottom: 16px;
    flex-direction: column;
    border-radius: 0;
  }

  .global__badge {
    left: 18px;
    top: 11px;
  }
}
</style>
