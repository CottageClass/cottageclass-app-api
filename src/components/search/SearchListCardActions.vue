<template>
   <ul class="button-list">
    <li>
      <IconButton label="Interested" :icon="starIcon" @click="interestedClick"/>
    </li>
    <li v-if="showGoingButton">
      <IconButton  label="Going" :icon="goingIcon" @click="goingClick"/>
    </li>
    <li v-if="event">
      <IconButton label="Contact" :icon="contactIcon" @click="contactClick"/>
    </li>
    <li v-if="event">
      <IconButton label="Share" :icon="shareIcon" @click="shareClick"/>
    </li>
  </ul>
</template>

<script>
import IconButton from '@/components/search/IconButton'

import { starEvent, unstarEvent, starUser, unstarUser } from '@/utils/api/stars'

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
    showGoingButton: { default: false }
  },
  components: { IconButton },
  computed: {
    shareIcon () { return shareIcon },
    contactIcon () { return contactIcon },
    goingIcon () {
      return this.event.participated ? goingIconActive : goingIconInactive
    },
    starIcon () {
      return this.item.starred ? starredIconActive : starredIconInactive
    },
    item () {
      if (this.event) { return this.event }
      if (this.user) { return this.user }
      throw Error('No valid item on this list card')
    }
  },
  methods: {
    async interestedClick () {
      let res
      if (this.event) {
        if (this.event.starred) {
          res = await unstarEvent(this.event.id)
        } else {
          res = await starEvent(this.event.id)
        }
        this.$emit('event-updated', res)
      } else if (this.user) {
        if (this.user.starred) {
          res = await unstarUser(this.user.id)
        } else {
          res = await starUser(this.user.id)
        }
        this.$emit('user-updated', res)
      }
    },
    goingClick () {
      if (this.event.participated) {
        this.$router.push({ name: 'CancelRSVP', params: { eventId: this.event.id } })
      } else {
        this.$router.push({ name: 'RsvpInfoCollection', params: { eventId: this.event.id } })
      }
    },
    contactClick () {
      this.$router.push({ name: 'ContactForm', params: { eventId: this.event.id } })
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
