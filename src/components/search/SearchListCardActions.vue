<template>
   <ul class="button-list">
    <li v-if="showInterestedButton">
      <IconButton label="Interested" :icon="starIcon" @click="interestedClick"/>
    </li>
    <li v-if="showGoingButton">
      <IconButton
        class="going-button"
        label="Going"
        :icon="goingIcon"
        @click="goingClick"/>
    </li>
    <li v-if="showMeetButton">
      <MeetButton
        defaultText="Say hi"
        :icon="contactIcon"
        :targetUser="user"
        :allowUndo="allowWaveUndo"/>
    </li>
    <li v-if="showContactButton">
      <IconButton label="Respond" :icon="contactIcon" @click="contactClick"/>
    </li>
    <li v-if="showCancelButton">
      <IconButton label="Cancel" @click="cancelClick"/>
    </li>
    <li v-if="showShareButton">
      <IconButton label="Share" :icon="shareIcon" @click="shareClick"/>
    </li>
  </ul>
</template>

<script>
import MeetButton from '@/components/base/MeetButton'
import IconButton from '@/components/search/IconButton'

import { starUser, unstarUser, deleteEvent } from '@/utils/api'
import { mapGetters } from 'vuex'
import { rsvp, redirect, alerts } from '@/mixins'

import shareIcon from '@/assets/share-black-outline.svg'
import contactIcon from '@/assets/contact-black-outline.svg'
import goingIconActive from '@/assets/going__green.svg'
import goingIconInactive from '@/assets/going-black-outline.svg'
import starredIconActive from '@/assets/star_2.svg'
import starredIconInactive from '@/assets/star-black-outline.svg'

export default {
  name: 'SearchListCardActions',
  props: {
    user: {},
    event: {},
    timePast: {},
    showContactButton: { default: false },
    showShareButton: { default: false },
    showGoingButton: { default: false },
    showInterestedButton: { default: false },
    showMeetButton: { default: false },
    showCancelButton: { default: false },
    allowWaveUndo: { default: false }
  },
  mixins: [rsvp, redirect, alerts],
  components: { IconButton, MeetButton },
  computed: {
    shareIcon () { return shareIcon },
    contactIcon () { return contactIcon },
    goingIcon () {
      return this.event.participated ? goingIconActive : goingIconInactive
    },
    starIcon () {
      return this.user.starred ? starredIconActive : starredIconInactive
    },
    item () {
      if (this.event) { return this.event }
      if (this.user) { return this.user }
      throw Error('No valid item on this list card')
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    async interestedClick () {
      let res
      if (this.user.starred) {
        res = await unstarUser(this.user.id)
      } else {
        res = await starUser(this.user.id)
      }
      this.$emit('user-updated', res)
    },
    contactClick () {
      this.$router.push({ name: 'ContactUserForm', params: { userId: this.user.id } })
    },
    goingClick () {
      if (this.redirectToSignupIfNotAuthenticated({
        name: 'RsvpInfoCollection',
        params: { eventId: this.event.id }
      })) {
      } else if (this.event.participated) {
        this.$router.push({ name: 'CancelRSVP', params: { eventId: this.event.id } })
      } else {
        if (this.currentUser.children.length === 1) {
          this.submitRsvp(this.currentUser.children.map(c => c.id))
        } else {
          this.$router.push({ name: 'RsvpInfoCollection', params: { eventId: this.event.id } })
        }
      }
    },
    cancelClick () {
      deleteEvent(this.event.id, () => {
        this.$emit('event-deleted', this.event.id)
        this.showBriefAllert('Your event has been deleted', 'success')
      })
    },
    shareClick () {
      this.$router.push({ name: 'SocialInvite', params: { id: this.event.id, context: 'searchItem' } })
    }
  },
  mounted () {
  }
}
</script>

<style scoped>
.button-list {
  list-style-type: none;
  display: flex;
  margin-top: 20px;
  margin-right: -8px;
  margin-bottom: 0;
  padding-left: 0;
  list-style-type: none;
}

@media (max-width: 479px){
  .footer__button-list {
    width: 100%;
    margin-top: 16px;
    flex-direction: column;
  }
}

</style>
