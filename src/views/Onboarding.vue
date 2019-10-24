<template>
  <div class="onb-body">
    <UserInformation v-if="section==='user-info'"
                     @set-nav-props="$emit('set-nav-props', $event)"
                     :stepName="stepName"
                     @finished="finishOnboarding" />
  </div>
</template>

<script>
import UserInformation from '@/components/FTE/userInformation/UserInformation'

import { mapGetters } from 'vuex'
import { goHome } from '@/mixins'

export default {
  name: 'Onboarding',
  props: ['stepName', 'section'],
  components: { UserInformation },
  mixins: [ goHome ],
  computed: mapGetters([ 'redirectRoute' ]),
  methods: {
    finishOnboarding () {
      this.$store.dispatch('updateCurrentUserFromServer')
      if (this.redirectRoute) {
        this.$router.push(this.redirectRoute)
      } else {
        this.goHome()
      }
    }
  },
  created () {
    if (!this.section) {
      this.$router.replace({ params: { section: 'user-info' } })
    }
  }
}
</script>
