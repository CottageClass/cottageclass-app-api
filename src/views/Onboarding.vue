<template>
  <div class="onb-body">
    <UserInformation v-if="section==='user-info'"
                     @set-nav-props="$emit('set-nav-props', $event)"
                     :stepName="stepName"
                     @finished="collectUserDetails" />
    <UserDetails v-if="section==='user-details'"
                 :stepName="stepName"
                 @finished="finishOnboarding" />
  </div>
</template>

<script>
import UserInformation from '@/components/FTE/userInformation/UserInformation'
import UserDetails from '@/components/FTE/userInformation/UserDetails'

import { mapGetters } from 'vuex'

export default {
  name: 'Onboarding',
  props: ['stepName', 'section'],
  components: { UserInformation, UserDetails },
  computed: mapGetters([ 'redirectRoute' ]),
  methods: {
    finishOnboarding () {
      this.$store.dispatch('updateCurrentUserFromServer')
      if (this.redirectRoute) {
        this.$router.push(this.redirectRoute)
      } else {
        this.$router.push({ name: 'Events' })
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
