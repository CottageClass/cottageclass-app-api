<template>

  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <StyleWrapper styleIs="onboarding">
          <Nav button="skip" @next="$router.push({name:'Events'})" hidePrevious="true" />
          <div class="onb-content-container">
            <div class="onb-top-content-container">
              <h1 class="onb-heading-large">{{ titleText }}</h1>
            </div>
            <LoadingSpinner v-if="!events" />
            <div v-else v-for="event in events">
              <OtherEvent :event="event"
                          @item-click="processRSVP(event)"/>
            </div>
            <a class="wave-button"
               @click="handleWave">
              {{waveButtonText}}
            </a>
          </div>
        </StyleWrapper>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex'

import Nav from '@/components/FTE/Nav'
import StyleWrapper from '@/components/FTE/StyleWrapper'
import LoadingSpinner from '@/components/LoadingSpinner'
import OtherEvent from '@/components/OtherEvent'

import { fetchUser, fetchUpcomingEvents } from '@/utils/api'
import { rsvp, waves } from '@/mixins'

export default {
  name: 'SelectEventFromUser',
  props: ['userId'],
  components: { Nav, StyleWrapper, LoadingSpinner, OtherEvent },
  mixins: [ rsvp, waves ],
  data () {
    return {
      events: null,
      targetUser: null
    }
  },
  computed: {
    titleText: () => 'Great! Pick a time that works for you.',
    waveButtonText () {
      return 'Say hi & propose another time'
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    processRSVP (event) {
      if (this.currentUser.children.length === 1) {
        this.event = event // this is to trick the mixin
        this.submitRsvp(this.currentUser.children.map(c => c.id))
      } else {
        this.$router.push({ name: 'RsvpInfoCollection', params: { eventId: event.id } })
      }
    },
    ...mapMutations(['addPendingWave'])
  },
  async created () {
    this.events = await fetchUpcomingEvents(this.userId)
    this.events = this.events.filter(e => !e.participated)

    this.targetUser = await fetchUser(this.userId)
  }
}
</script>

<style scoped>
.onb-content-container {
  font-family: soleil;
  display: flex;
  flex-direction: column;
}
.wave-button {
  display: block;
  &:hover {
    background-color: #F0F0F0;
  }
  background-color: #b3d4fc;
  border-radius: 4px;
  color: #158BE7;
  padding: 12px 25px;
  font-variant: small-caps;
  text-align: center;
  cursor: pointer;
  margin-right: auto;
  margin-left: auto;
  margin-top: 45px;
  margin-bottom: 32px;
}
@media (max-width: 479px) {

}

</style>
