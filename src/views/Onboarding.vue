<template>
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <StyleWrapper styleIs="onboarding">
          <UserInformation v-if="section==='user-info'"
                           :stepName="stepName"
                           @finished="finishUserInfo"/>
          <CreateEvent v-if="section==='offering'"
                       :stepName="stepName"
                       context="onboarding"
                       @finished="collectHomeInfo"
                       @skip="collectUserDetails"
                       />
          <HouseInformation v-if="section==='home-info'"
                            :stepName="stepName"
                            context="onboarding"
                            @finished="collectUserDetails" />
          <UserDetails v-if="section==='user-details'"
                       :stepName="stepName"
                       @finished="finsishOnboarding" />
        </StyleWrapper>
      </div>
    </div>
  </div>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper'
import UserInformation from '@/components/FTE/userInformation/UserInformation'
import UserDetails from '@/components/FTE/userInformation/UserDetails'
import CreateEvent from '@/components/CreateEvent'
import HouseInformation from '@/components/FTE/userInformation/HouseInformation'

import { mapGetters } from 'vuex'

export default {
  name: 'Onboarding',
  props: ['stepName', 'section'],
  components: { StyleWrapper, UserInformation, CreateEvent, HouseInformation, UserDetails },
  computed: mapGetters([ 'redirectRoute', 'firstCreatedEvent' ]),
  methods: {
    finsishOnboarding () {
      if (this.redirectRoute) {
        this.$router.push(this.redirectRoute)
      } else {
        if (this.firstCreatedEvent) {
          this.$router.push({ name: 'SocialInvite', params: { id: this.firstCreatedEvent.id } })
        } else {
          // in the case that the event creation was skipped, we go straight to home
          this.$router.push({ name: 'Events' })
        }
      }
    },
    collectUserDetails () {
      this.$router.push({ params: { section: 'user-details', stepName: null } })
    },
    collectHomeInfo () {
      this.$router.push({ params: { section: 'home-info', stepName: null } })
    },
    finishUserInfo (e) {
      this.$router.push({ params: { section: 'offering', stepName: null } })
    }
  },
  created () {
    if (!this.section) {
      this.$router.push({ params: { section: 'user-info' } })
    }
  }
}
</script>
