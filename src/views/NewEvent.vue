<template>
  <div class="onb-body">
    <CreateEvent v-if="section==='event'"
                 :stepName="stepName"
                 v-on:submission-complete="findUpcomingEvent"
                 @finishedHomeEvent="proceed"
                 @finishedPublicEvent="proceed"
                 @set-nav-props="$emit('set-nav-props', $event)"
                 context="new-event"
    />
  </div>
</template>

<script>
import CreateEvent from '@/components/CreateEvent'

import { mapGetters } from 'vuex'
import { redirect } from '@/mixins'

export default {
  name: 'NewEvent',
  components: { CreateEvent },
  mixins: [redirect],
  props: ['stepName'],
  data () {
    return {
      upcomingEvent: null,
      section: 'event'
    }
  },
  computed: mapGetters(['currentUser', 'pendingWaves']),
  methods: {
    proceed () {
      this.$router.push({ name: 'SocialEventInvite', params: { id: this.upcomingEvent.id, context: 'spontaneous' } })
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
