<template>
<StyleWrapper styleIs="onboarding">

  <!-- wrapper for desktop screens -->

    <div class="onb-body">
      <div class="body">
        <div class="content-wrapper">
  <Nav
  :button="nextButtonState"
  @next="nextStep"
  @prev="$router.go(-1)" />
  <ErrorMessage v-if="err" :text="err" />
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
</div>
</div>
</StyleWrapper>
</template>

<script>
import { mapGetters } from 'vuex'

import { fetchEvent } from '@/utils/api'
import * as utils from '@/utils/utils.js'
import { redirect, rsvp } from '@/mixins'

import Nav from '@/components/FTE/Nav.vue'
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import Question from '@/components/base/Question.vue'
import Checkboxes from '@/components/base/Checkboxes.vue'
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import LoadingSpinner from '@/components/LoadingSpinner.vue'

var moment = require('moment')

export default {
  name: 'RsvpInfoCollection',
  components: { Nav, LoadingSpinner, ErrorMessage, Checkboxes, StyleWrapper, Question },
  mixins: [ redirect, rsvp ],
  data () {
    return {
      childrenSelected: [],
      err: '',
      eventId: this.$route.params.eventId,
      event: false
    }
  },
  created: function () {
    if (this.redirectToSignupIfNotAuthenticated()) { return }
    this.redirectToOnboardingIfNotOnboarded()
    this.showErrorIfUserHasNoChildren()
  },
  mounted: function () {
    // get data about the current event to determine max attendees.
    this.fetchEventInformation()
  },
  computed: {
    spotsRemainingPhrase: function () {
      return 'There ' + (this.spotsRemaining === 1 ? 'is' : 'are') + ' ' + this.spotsRemaining + ' spot' + (this.spotsRemaining !== 1 ? 's' : '') + ' remaining.'
    },
    labelsAndOrder: function () {
      return this.children.map(child => [child.id, child.firstName + ', ' + this.calculateAge(child.birthday)])
    },
    allInformationLoaded: function () {
      return this.currentUser && this.event
    },
    tooManyChildren: function () {
      return this.childrenSelected.length > this.event.maximumChildren - this.event.participantsCount
    },
    nextButtonState: function () {
      if (this.tooManyChildren || this.childrenSelected.length === 0) {
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
    showErrorIfUserHasNoChildren: function () {
      if (!this.children || this.children.length === 0) {
        this.err = 'Sorry, but we cannot retrieve your children\'s information. Are you sure you have signed in? To resolve this, please email us at: contact@cottageclass.com.'
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
        if (this.event.full || this.event.maximumChildren === 0) {
          this.err = 'We\'re sorry, this event is full!'
        }
      } catch (err) {
        console.log(err.stack)
        this.err = 'Sorry, there was a problem retrieving information about the event. Go back and try again?'
      }
    },
    nextStep: function () {
      if (this.tooManyChildren) {
        let numChildren = this.childrenSelected.length
        let childrenSingularOrPlural = numChildren === 1 ? 'child' : 'children'
        this.err = 'Sorry, but there are not enough spots available for ' + numChildren + ' ' + childrenSingularOrPlural + '.'
      } else if (this.childrenSelected.length === 0) {
        this.err = 'Please choose at least one child to RSVP.'
      } else {
        this.submitRsvp(this.childrenSelected)
      }
    },
    isSelected: function (id) {
      return this.childrenSelected.includes(id)
    },
    toggleSelected: function (id) {
      this.err = ''
      if (this.isSelected(id)) {
        this.childrenSelected = this.childrenSelected.filter((aChildId) => aChildId !== id)
      } else {
        this.childrenSelected.push(id)
      }
    }
  }
}
</script>
