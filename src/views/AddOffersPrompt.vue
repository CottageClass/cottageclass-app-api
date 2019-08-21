<template>
<StyleWrapper styleIs="onboarding">
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <Nav button="none"
             @prev="$router.go(-1)"
             :hidePrevious="false" />
        <div v-if="user" class="onb-content-container">
          <div class="onb-top-content-container">
            <h1 class="onb-heading-large">{{ titleText }}</h1>
            <p class="onb-paragraph-subheading-2">{{ questionText }}</p>
          </div>
            <div class="action-bar">
              <button class="button" @click="goToCreateOffers">Yes</button>
              <button class="button" @click="skipCreateOffers">No</button>
            </div>
        </div>
        <LoadingSpinner v-else />
      </div>
    </div>
  </div>
</StyleWrapper>
</template>

<script>
import Nav from '@/components/FTE/Nav'
import StyleWrapper from '@/components/FTE/StyleWrapper'
import LoadingSpinner from '@/components/LoadingSpinner'

import { fetchUser } from '@/utils/api'
import { messaging } from '@/mixins'

export default {
  name: 'SelectEventFromUser',
  props: ['userId'],
  mixins: [ messaging ],
  components: { Nav, StyleWrapper, LoadingSpinner },
  data () {
    return {
      user: null
    }
  },
  computed: {
    titleText: () => 'Would you like to offer some times to meet?',
    questionText () {
      return 'You haven\'t offered any upcoming times yet, so we strongly reommend offering some before saying hi to ' +
             this.user.firstName +
             '. It will make scheduling a playdate so much simpler!'
    }
  },
  methods: {
    goToCreateOffers () {
      this.$router.push({ name: 'NewEvent' })
    },
    async skipCreateOffers () {
      try {
        await this.settlePendingWaves()
      } catch (e) {
        this.logError(e)
      } finally {
        this.$router.push({ name: 'Search' })
      }
    }
  },
  async created () {
    this.user = await fetchUser(this.userId)
  }
}
</script>

<style scoped>
.button {
  width: 50%;
  padding: 12px 32px;
  margin: 10px;
  border-radius: 4px;
  background-color: #fff;
  color: #1f88e9;
  font-size: 13px;
  font-weight: 700;
  text-align: center;
  letter-spacing: 1.2px;
  text-decoration: none;
  text-transform: uppercase;
}
.action-bar {
  display: flex;
  width: 100%;
  margin-top: 24px;
  justify-content: space-between;
  align-items: center;
}
.onb-content-container {
  font-family: soleil;
}
@media (max-width: 479px) {
}

</style>
