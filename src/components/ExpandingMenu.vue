<template>
  <div class="nav-links-expanded">
    <ul class="unordered-list-2 w-list-unstyled">
      <li>
        <a href="/events/new" class="link-block w-inline-block">
          <div class="text-block">Offer a playdate</div>
        </a>
      </li>
      <li>
        <a href="/profile/edit" class="link-block w-inline-block">
          <div class="text-block">Edit profile</div>
        </a>
      </li>
      <li>
        <router-link
          :to="'/users/' + currentUser.id"
          class="link-block w-inline-block">
          <div class="text-block">View profile</div>
        </router-link>
      </li>
      <li>
        <router-link to="/faq" class="link-block w-inline-block">
          <div class="text-block">FAQ</div>
        </router-link>
      </li>
      <li>
        <a @click.prevent="logout" href="" class="link-block w-inline-block">
          <div class="text-block">Logout</div>
        </a>
      </li>
    </ul>
  </div>
</template>

<script>
import { } from '@/mixins'
import { signOut } from '@/utils/api'
import { mapGetters } from 'vuex'

export default {
  name: 'ExpandingMenu',
  props: [],
  components: {},
  mixins: [],
  data () {
    return {
    }
  },
  methods: {
    logout: function () {
      signOut().then(() => {
        this.$store.dispatch('establishUser', { JWT: null })
        this.$router.push({ name: 'SplashPage' })
        this.showMenu = false
      })
    }
  },
  computed: {
    ...mapGetters(['currentUser'])
  }
}
</script>

<style scoped>

.nav-links-expanded {
  position: absolute;
  top: 84px;
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

.text-block {
  width: 100%;
  color: #000;
  text-decoration: none;
}
.link-block {
  color: #000;
  text-decoration: none;
  font-weight: normal;
  width: 100%;
  padding: 14px 16px 14px 24px;
}

.link-block:hover {
  background-color: rgba(0, 0, 0, .04);
}

@media (max-width: 767px) {
  .link-block {
    padding-top: 16px;
    padding-bottom: 16px;
  }
  .nav-links-expanded {
    top: 58px;
    right: 0px;
    width: 100%;
  }
}
@media (max-width: 479px) {
  .nav-links-expanded {
    top: 70px;
  }
}
</style>
