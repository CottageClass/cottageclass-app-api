<template>
  <div>
    <LoadingSpinner v-if="!allInformationLoaded"/>
    <Question
      v-if="allInformationLoaded"
      title="Which children are going?"
      :subtitle="spotsRemainingPhrase"
    >
      <Checkboxes
        v-model="childrenSelected"
        :labels="labelsAndOrder"/>
    </Question>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

import { fetchEvent } from '@/utils/api'
import * as utils from '@/utils/utils.js'
import { redirect, rsvp, validationError } from '@/mixins'

import Question from '@/components/base/Question.vue'
import Checkboxes from '@/components/base/Checkboxes.vue'
import LoadingSpinner from '@/components/LoadingSpinner.vue'

var moment = require('moment')

export default {
  name: 'RsvpInfoCollection',
  components: { LoadingSpinner, Checkboxes, Question },
  mixins: [ redirect, rsvp, validationError ],
  data () {
    return {
      childrenSelected: [],
      eventId: this.$route.params.eventId,
      event: false
    }
  },
  async created () {
    this.$emit('set-nav-props', {
      nextButtonHandler: this.nextStep,
      prevButtonHandler: () => { this.$router.go(-1) },
      button: this.nextButtonState
    })
    if (this.redirectToSignupIfNotAuthenticated()) { return }
    this.redirectToOnboardingIfNotOnboarded()
    await this.selectSingleChild()
  },
  mounted: function () {
    // get data about the current event to determine max attendees.
    this.fetchEventInformation()
  },
  watch: {
    nextButtonState () {
      this.$emit('set-nav-props', {
        button: this.nextButtonState
      })
    }
  },
  computed: {
    validationError () {
      if (!this.children || this.children.length === 0) {
        return 'Sorry, but we cannot retrieve your children\'s information. Are you sure you have signed in? To resolve this, please email us at: contact@joinlilypad.com.'
      }
      if (this.childrenSelected.length === 0) {
        return 'Please choose at least one child to RSVP.'
      }
      return null
    },
    spotsRemainingPhrase: function () {
      return 'There ' + (this.spotsRemaining === 1 ? 'is' : 'are') + ' ' + this.spotsRemaining + ' spot' + (this.spotsRemaining !== 1 ? 's' : '') + ' remaining.'
    },
    labelsAndOrder: function () {
      return this.children.map(child => [child.id, child.firstName + ', ' + this.calculateAge(child.birthday)])
    },
    allInformationLoaded: function () {
      return this.currentUser && this.event
    },
    nextButtonState: function () {
      if (this.childrenSelected.length === 0) {
        return 'inactive'
      } else {
        return 'next'
      }
    },
    spotsRemaining: function () {
      return Math.max(0, this.event.maximumChildren - this.event.participantsCount - this.childrenSelected.length)
    },
    guestChildrenNamesAgesFormatted: function () {
      return utils.arrayToSentence(this.children.filter(child => this.childrenSelected.includes(child.id)).map(child => child.firstName + ' (age ' + this.calculateAge(child.birthday) + ')')) // 'Suzie (5)'
    },
    children: function () {
      return this.currentUser.children
    },
    ...mapGetters([ 'currentUser', 'isAuthenticated' ])
  },
  methods: {
    async selectSingleChild () {
      if (!this.evnet) {
        await this.fetchEventInformation()
      }
      if (this.children.length === 1) {
        this.childrenSelected.push(this.children[0].id)
        await this.submitRsvp(this.childrenSelected)
        this.$router.replace({ name: 'EventPage', params: { id: this.event.id } })
      }
    },
    redirectToOnboardingIfNotOnboarded: function () {
      if (!this.currentUser.hasAllRequiredFields) {
        // send them back to onboarding.
        console.log('user doesnt have required fields on rsvpinfocollection step, sending them back to onboarding', this.currentUser)
        this.setRedirectRouteHere()
        this.$router.push({ name: 'Onboarding' })
      } else {
        console.log('user already onboarded, not redirecting')
      }
    },
    calculateAge: function (birthdate) {
      return moment().diff(birthdate, 'years')
    },
    fetchEventInformation: async function () {
      try {
        this.event = await fetchEvent(this.$route.params.eventId)
      } catch (err) {
        console.log(err.stack)
      }
    },
    async nextStep () {
      if (this.validationError) { return }
      if (this.event.participated) {
        this.$router.push({ name: 'EventPage', params: { id: this.event.id } })
      } else {
        await this.submitRsvp(this.childrenSelected)
      }
    }
  }
}
</script>
