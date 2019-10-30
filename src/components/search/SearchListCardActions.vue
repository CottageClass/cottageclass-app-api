<template>
  <ul class="button-list">
    <li v-if="showEditButton">
      <IconButton
        class="edit-button"
        label="Edit"
        :icon="editIcon"
        @click="$emit('edit-click')"/>
    </li>
    <li v-if="showInterestedButton">
      <IconButton
        class="interested-button"
        label="Interested"
        :icon="starIcon"
        @click="$emit('interested-click')"/>
    </li>
    <li v-if="showGoingButton">
      <IconButton
        class="going-button"
        label="Going"
        :icon="goingIcon"
        @click="$emit('going-click')"/>
    </li>
    <li v-if="showContactButton">
      <IconButton
        class="contact-button"
        label="Contact"
        :icon="contactIcon"
        @click="$emit('contact-click')"/>
    </li>
    <li v-if="showCancelButton">
      <IconButton
        class="cancel-button"
        label="Cancel"
        @click="$emit('cancel-click')"/>
    </li>
    <li v-if="showShareButton">
      <IconButton
        class='share-button'
        label="Share"
        :icon="shareIcon"
        @click="$emit('share-click')"/>
    </li>
  </ul>
</template>

<script>
import IconButton from '@/components/search/IconButton'

import { mapGetters } from 'vuex'
import { rsvp, redirect, alerts } from '@/mixins'

import shareIcon from '@/assets/share-black-outline.svg'
import contactIcon from '@/assets/contact-black-outline.svg'
import editIcon from '@/assets/compose.svg'
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
    showEditButton: { default: false },
    showShareButton: { default: false },
    showGoingButton: { default: false },
    showInterestedButton: { default: false },
    showContactButton: { default: false },
    showCancelButton: { default: false }
  },
  mixins: [rsvp, redirect, alerts],
  components: { IconButton },
  computed: {
    shareIcon () { return shareIcon },
    editIcon () { return editIcon },
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
