<template>
   <ul class="button-list">
    <li>
      <IconButton label="Interested" :icon="starIcon" @click="interestedClick"/>
    </li>
    <li>
      <IconButton v-if="eventId" label="Going" :icon="goingIcon" @click="goingClick"/>
    </li>
    <li>
      <IconButton v-if="eventId" label="Contact" :icon="contactIcon" @click="contactClick"/>
    </li>
    <li>
      <IconButton v-if="eventId" label="Share" :icon="shareIcon" @click="shareClick"/>
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
    isStarred: { required: true },
    isGoing: {},
    eventId: {}
  },
  components: { IconButton },
  data () {
    return {
    }
  },
  computed: {
    shareIcon () { return shareIcon },
    contactIcon () { return contactIcon },
    goingIcon () {
      return this.isGoing ? goingIconActive : goingIconInactive
    },
    starIcon () {
      return this.isStarred ? starredIconActive : starredIconInactive
    }
  },
  methods: {
    interestedClick () {
      if (this.eventId) {
        if (this.isStarred) {
          starEvent(this.eventId)
        } else {
          unstarEvent(this.eventId)
        }
      } else if (this.userId) {
        if (this.isStarred) {
          starUser(this.eventId)
        } else {
          unstarUser(this.eventId)
        }
      }
    },
    goingClick () {
      this.$router.push({ name: 'RsvpInfoCollection', params: { eventId: this.eventId } })
    },
    contactClick () {
      this.$router.push({ name: 'ContactForm', params: { eventId: this.eventId } })
    },
    shareClick () {
      this.$router.push({ name: 'SocialInvite', params: { id: this.eventId, context: 'searchItem' } })
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
