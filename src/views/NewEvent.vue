<template>
  <div class="onb-body">
    <div class="content-wrapper">
      <StyleWrapper styleIs="onboarding">
        <CreateEvent v-if="section==='event'"
                     :stepName="stepName"
                     v-on:submission-complete="findUpcomingEvent"
                     @finishedHomeEvent="completeCreationForHomeEvents"
                     @finishedPublicEvent="proceed"
                     context="new-event"
        />
        <HouseInformation v-if="section==='homeInfo'"
                          :stepName="stepName"
                          @finished="proceed"
                          context="new-event"
        />
      </StyleWrapper>
    </div>
  </div>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper'
import CreateEvent from '@/components/CreateEvent'
import HouseInformation from '@/components/FTE/userInformation/HouseInformation'

import { mapGetters } from 'vuex'
import { redirect } from '@/mixins'

export default {
  name: 'NewEvent',
  components: { StyleWrapper, CreateEvent, HouseInformation },
  mixins: [redirect],
  props: ['stepName'],
  data () {
    return {
      section: 'event'
    }
  },
  computed: mapGetters(['currentUser', 'pendingWaves']),
  methods: {
    proceed () {
      this.$router.push({ name: 'SocialEventInvite', params: { id: this.upcomingEvent.id, context: 'spontaneous' } })
    },
    completeCreationForHomeEvents () {
      if (this.currentUser.houseRules === null) {
        this.section = 'homeInfo'
      } else {
        this.proceed()
      }
    },
    findUpcomingEvent (value) {
      this.upcomingEvent = value[0]
    }
  },
  created () {
    this.redirectToSignupIfNotAuthenticated()
    this.$store.dispatch('updateCurrentUserFromServer')
  }
}
</script>

<style scoped>

.onb-body {
  background-color: #0d73c7;
}

.content-wrapper {
  width: 720px;
  min-height: 100vh;
  margin-right: auto;
  margin-left: auto;
  padding-bottom: 50px;
  background-color: #1c8be7;
}
@media (max-width: 991px) {
  .content-wrapper {
    width: 670px;
  }
}

@media (max-width: 767px) {
  .content-wrapper {
    width: 100%;
    margin-top: 0px;
    margin-bottom: 0px;
  }
}
</style>
