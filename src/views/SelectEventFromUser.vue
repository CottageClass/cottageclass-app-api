<template>
<StyleWrapper styleIs="onboarding">
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <Nav button="skip" @next="$router.go(-1)" hidePrevious="true" />
        <div class="onb-content-container">
          <div class="onb-top-content-container">
            <h1 class="onb-heading-large">{{ titleText }}</h1>
          </div>
          <LoadingSpinner v-if="!events" />
          <div v-else v-for="event in events">
            <OtherEvent :event="event"
                        @item-click="processRSVP(event)"/>
          </div>
        </div>
        <a class="wave-button"
           @click="handleWave">
          Just say hi!
        </a>
      </div>
    </div>
  </div>
</StyleWrapper>
</template>

<script>
import { mapGetters } from 'vuex'

import Nav from '@/components/FTE/Nav'
import StyleWrapper from '@/components/FTE/StyleWrapper'
import LoadingSpinner from '@/components/LoadingSpinner'
import OtherEvent from '@/components/OtherEvent'

import { fetchUpcomingEvents, fetchUser } from '@/utils/api'
import { rsvp, waves, alerts } from '@/mixins'

export default {
  name: 'SelectEventFromUser',
  props: ['userId'],
  components: { Nav, StyleWrapper, LoadingSpinner, OtherEvent },
  mixins: [rsvp, waves, alerts],
  data () {
    return {
      events: null,
      targetUser: null
    }
  },
  computed: {
    titleText: () => 'Great! Pick a time that works for you.',
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
    async handleWave () {
      try {
        await this.sendMessage()
        this.showAlertOnNextRoute('You message has been sent', 'success')
      } catch (e) {
        this.logError(e)
        this.showAlertOnNextRoute('Something went wrong.  Please try again later', 'failure')
      } finally {
        this.$router.push({ name: 'UserPage', params: { id: this.userId } })
      }
    }
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
}
.wave-button {
  display: block;
  &:hover {
    background-color: #F0F0F0;
  }
  background-color: #b3d4fc;
  border-radius: 4px;
  color: #158BE7;
  padding: 12px 5px;
  font-variant: small-caps;
  width: 40%;
  text-align: center;
  cursor: pointer;
  margin-right: auto;
  margin-left: auto;
  margin-top: 3px;
  margin-bottom: 32px;
}
@media (max-width: 479px) {
  .wave-button {
    width: 60%;
  }
}

</style>
