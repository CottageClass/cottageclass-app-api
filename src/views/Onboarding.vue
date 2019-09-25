<template>
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <StyleWrapper styleIs="onboarding">
          <UserInformation v-if="section==='user-info'"
                           :stepName="stepName"
                           @finished="collectUserDetails" />
          <UserDetails v-if="section==='user-details'"
                       :stepName="stepName"
                       @finished="finishOnboarding" />
        </StyleWrapper>
      </div>
    </div>
  </div>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper'
import UserInformation from '@/components/FTE/userInformation/UserInformation'
import UserDetails from '@/components/FTE/userInformation/UserDetails'

import { mapGetters } from 'vuex'

export default {
  name: 'Onboarding',
  props: ['stepName', 'section'],
  components: { StyleWrapper, UserInformation, UserDetails },
  computed: mapGetters([ 'redirectRoute', 'firstCreatedEvent' ]),
  methods: {
    finishOnboarding () {
      if (this.redirectRoute) {
        this.$router.push(this.redirectRoute)
      } else {
        this.$router.push({ name: 'Search' })
      }
    },
    collectUserDetails () {
      this.$router.push({ params: { section: 'user-details', stepName: null } })
    }
  },
  created () {
    if (!this.section) {
      this.$router.replace({ params: { section: 'user-info' } })
    }
  }
}
</script>
