<template>
  <span>
    <Login class="onb-body"
    v-if="activeScreen ==='facebook' && step === 0"
    v-on:userNotYetOnboarded="nextStep"
    v-on:activateScreen="activateScreen"
    v-on:userAlreadyOnboarded="proceedToHomePage"
    v-on:authenticateFacebook="authenticate('facebook')"
     />
    <LoginWithEmail
    v-if="activeScreen ==='loginWithEmail' && step === 0"
    v-on:userNotYetOnboarded="nextStep"
    v-on:activateScreen="activateScreen"
    v-on:userAlreadyOnboarded="proceedToHomePage"
    v-on:authenticateFacebook="authenticate('facebook')"
     />
    <Signup
    v-if="activeScreen ==='signup' && step === 0"
    v-on:userNotYetOnboarded="nextStep"
    v-on:activateScreen="activateScreen"
    v-on:userAlreadyOnboarded="proceedToHomePage"
    v-on:authenticateFacebook="authenticate('facebook')"
     />
    <Invite
    v-if="activeScreen === 'inviteOthers'"
    v-on:activateScreen="activateScreen"
    :eventData="createdEventData"
    @prev="backFromInviteStep"
    />
    <InviteExistingUsers
    v-if="activeScreen === 'inviteExistingUsers'"
    :eventData="createdEventData"
    @prev="backFromInviteExistingStep"
    />
    <RSVPPrompt
    v-on:activateScreen="activateScreen"
    v-if="activeScreen === 'RSVPPrompt'"
    />

  <!-- wrapper for desktop screens -->

    <div class="onb-body" v-if="step !== 0">
      <div class="body">
        <div class="content-wrapper">

  <!-- nav -->

      <Nav :button="nextButtonState" @next="nextStep" @prev="prevStep" />

  <!-- error message -->

      <ErrorMessage v-if="showError && error && error!='skippable'" :text="error" />

  <!-- steps in form -->
  <StyleWrapper styleIs="onboarding">
      <Phone v-if="step === 1" v-model="phone" @pressedEnter="nextStep" required="true" />
      <Location v-if="step === 2" v-model="location" @pressedEnter="nextStep"/>
      <Children v-if="step === 3" v-model="children" />
      <EventActivity v-if="step === 4" v-model="eventActivity" />
      <Food v-if="step === 5" v-model="food" />
      <EventTime v-if="step === 6" v-model="eventTime" />
      <EventDate v-if="step === 7" v-model="eventDate" />
      <MaxChildren v-if="step === 8" v-model="maxChildren" />
      <YesOrNo
      v-if="step === 9"
      v-model="canProvideEmergencyCare"
      question="Childcare in a Pinch?"
      description="Parents often need care at times not covered by our events. Would you like to be able to request childcare from other members when you need it and receive requests (by text message) in return?"
      />
      <Availability v-if="step === 10" v-model="availability" />
      <YesOrNo
      v-if="step === 11"
      v-model="hasPets"
      question="Do you have pets?"
      description="This is often very important for parents (and children) to know."
      />
      <PetsDescription v-if="step === 12" v-model="petsDescription" />
      <HouseRules v-if="step === 13" v-model="houseRules" />
  </StyleWrapper>

   <!-- close desktop wrapper -->
 </div>
</div>
    </div>
  </span>
</template>

<script>
import Nav from '@/components/onboarding/Nav.vue'
import ErrorMessage from '@/components/onboarding/ErrorMessage.vue'
import Login from '@/components/onboarding/Login.vue'
import LoginWithEmail from '@/components/onboarding/LoginWithEmail.vue'
import Signup from '@/components/onboarding/Signup.vue'
import Location from '@/components/onboarding/Location.vue'
import Phone from '@/components/onboarding/Phone.vue'
import Children from '@/components/onboarding/Children.vue'
import EventActivity from '@/components/onboarding/EventActivity.vue'
import Availability from '@/components/onboarding/Availability.vue'
import Food from '@/components/onboarding/Food.vue'
import HouseRules from '@/components/onboarding/HouseRules.vue'
import PetsDescription from '@/components/onboarding/PetsDescription.vue'
import EventTime from '@/components/onboarding/EventTime.vue'
import EventDate from '@/components/onboarding/EventDate.vue'
import MaxChildren from '@/components/onboarding/MaxChildren.vue'
import YesOrNo from '@/components/onboarding/YesOrNo.vue'
import RSVPPrompt from '@/components/onboarding/RSVPPrompt.vue'
import Invite from '@/components/onboarding/Invite.vue'
import InviteExistingUsers from '@/components/onboarding/InviteExistingUsers.vue'
import StyleWrapper from '@/components/onboarding/StyleWrapper.vue'
import * as Token from '@/utils/tokens.js'
import * as api from '@/utils/api.js'
import sheetsu from 'sheetsu-node'
import normalize from 'json-api-normalizer'
import { mapGetters } from 'vuex'

var moment = require('moment')

// create a config file to identify which spreadsheet we push to.
var client = sheetsu({ address: 'https://sheetsu.com/apis/v1.0su/62cd725d6088' })

export default {
  components: {
    Nav,
    Login,
    LoginWithEmail,
    Signup,
    Location,
    Phone,
    Children,
    Availability,
    Food,
    EventActivity,
    EventTime,
    EventDate,
    HouseRules,
    PetsDescription,
    YesOrNo,
    MaxChildren,
    Invite,
    StyleWrapper,
    ErrorMessage,
    RSVPPrompt,
    InviteExistingUsers
  },
  data () {
    return {
      createdEventData: null,
      activeScreen: this.$route.query.activeScreen || 'facebook',
      step: 0,
      lastStep: 13,
      showError: false,
      name: {}, // todo: remove if possible now this comes from FB
      location: {},
      phone: {},
      children: {
        list: [],
        err: 'skippable'
      },
      blurb: {
        text: ''
      },
      availability: {
        availableMornings: false,
        availableAfternoons: false,
        availableEvenings: false,
        availableWeekends: false,
        err: 'skippable'
      },
      food: {},
      eventActivity: {},
      eventTime: {},
      eventDate: {},
      houseRules: {
        err: 'skippable'
      },
      communityRules: {},
      hasPets: {
        yesOrNo: ''
      },
      petsDescription: {
        text: ''
      },
      invitationCode: {
        code: 'brooklyn-events' // this is now hard-coded
      },
      acceptsBackgroundCheck: {
        yesOrNo: ''
      },
      canProvideEmergencyCare: {
        yesOrNo: ''
      },
      maxChildren: null,
      rsvpAttempted: this.$cookies.get('rsvpAttempted'),
      childAgeMaximum: 11,
      childAgeMinimum: 2
    }
  },
  name: 'NewUser',
  mounted: function () {
    this.fetchUpcomingEvents()
  },
  methods: {
    proceedToHomePage: function () {
      console.log('proceedToHomePage')
      this.$store.dispatch('establishCurrentUserAsync', Token.currentUserId(this.$auth)).then(() => {
        this.$router.push({ name: 'Home' })
      })
    },
    fetchUpcomingEvents: function () {
      api.fetchEvents('upcoming/page/1/page_size/50').then(
        (res) => {
          window.globalEventList = res
        })
    },
    activateScreen: function (name) {
      console.log('activating:', name)
      this.activeScreen = name
    },
    capitalize: function (string) {
      return string.charAt(0).toUpperCase() + string.slice(1)
    },
    continueWhenComplete: function () {
      if (this.rsvpAttempted) {
        this.$router.push({ name: 'RsvpConfirmation', params: { eventId: this.rsvpAttempted } })
      } else {
        this.activateScreen('RSVPPrompt')
        this.step = 0
      }
    },
    skipSkippableSteps: function () {
      if (
        (this.step === 9 && !this.canProvideEmergencyCare.isTrue) ||
        (this.step === 11 && !this.hasPets.isTrue)) {
        this.setStep(this.step + 2)
      } else {
        this.setStep(this.step + 1)
      }
    },
    setStep: function (destinationStep) {
      this.step = destinationStep
    },
    nextStep: function () {
      if (this.step === this.lastStep) {
        this.submitData()
          .then(res => {
            this.continueWhenComplete()
          })
      } else if (!this.error || this.error === 'skippable') {
        // check if there's an error, if so show it, if not advance and clear the error.
        this.showError = false
        this.skipSkippableSteps()
        window.scrollTo(0, 0)
      } else {
        this.showError = true
      }
    },
    prevStep: function () {
      this.showError = false
      this.step = this.step - 1
    },
    backFromInviteStep: function () {
      this.step = this.lastStep
      this.activeScreen = null
    },
    backFromInviteExistingStep: function () {
      this.activateScreen('inviteOthers')
    },
    authenticate: function (provider) {
      /*
   *  Logs in the user (Facebook)
   * - follows OAuth flow using VueAuth to get OAuth code
   * - sends code to backend to exchange for access_token
   * - backend fetches access_token, stores it in DB, and sends back JWT for user
   * - VueAuthenticate stores JWT for future API access authorization
   */

      // store value of this to access this.$emit during callback
      let component = this
      this.$auth.authenticate(provider)
        .then(res => {
          console.log('auth SUCCESS')
          return this.$store.dispatch('establishCurrentUserAsync', Token.currentUserId(component.$auth))
        }).then(() => {
          if (this.currentUser.hasAllRequiredFields && !this.rsvpAttempted) {
            // redirect to home screen if they haven't attempted an RSVP
            this.$router.push({ name: 'Home' })
          } else if (this.currentUser.hasAllRequiredFields && this.rsvpAttempted) {
            // confirm that they want to RSVP if they have attempted an RSVP
            this.$router.push({ name: 'RsvpConfirmation', params: { eventId: this.rsvpAttempted } })
          } else if (this.currentUser.id) {
            // begin onboarding
            this.nextStep()
          } else {
            return false
          }
        }).catch(function (err) {
          console.log('auth FAILURE or user not onboarded yet')
          console.log(err)
        })
    },
    submitData: function () {
      // advance to loading indicator
      this.step = this.step + 1
      let userId = Token.currentUserId(this.$auth)

      // submit user to sheetsu for KPI tracking, unless network is "demo"
      if (this.invitationCode.code !== 'demo') {
        client.create({
          'ID': userId,
          'Date joined': moment(Date()).format('L'),
          'address': this.location.fullAddress,
          'phone': this.phone.number,
          'children': this.children.list,
          'availability': this.availability,
          'network': this.invitationCode.code,
          'food': this.food.selected
        }, 'newUsers').then((data) => {
          console.log(data)
        }, (err) => {
          console.log(err)
        })
      }

      // I think this is necessary but I'm not sure.
      let component = this
      let phone = this.phone
      let location = this.location
      let availability = this.availability
      let children = this.children
      return api.submitUserInfo(userId, phone, location, availability, children).then(res => {
        console.log('user update SUCCESS')
        console.log(res)
        return res
      })
        .catch(err => {
          console.log('user update FAILURE')
          console.log(err)
          console.log(Object.entries(err))
          // show on the houseRules step because it's the last step
          component.houseRules.err = 'Sorry, there was a problem saving your information. Try again?'
          throw err
        }).then(() => {
          return component.$store.dispatch('establishCurrentUserAsync', Token.currentUserId(component.$auth))
        }).then(() => {
          component.submitEventData().then(res => {
            component.createdEventData = normalize(res.data)
          })
        })
        .then(res => {
          console.log('event creation SUCCESS')
          console.log(res)
          return res
        })
        .catch(err => {
          console.log('event creation FAILURE')
          console.log(err)
          console.log(Object.entries(err))
          component.houseRules.err = 'Sorry, there was a problem saving your activity information. Try again?'
          throw err
        })
    },
    submitEventData: function () {
      return this.axios.post(`${process.env.BASE_URL_API}/api/event_series`, this.eventDataForSubmissionToAPI)
    }
  },
  computed: {
    error: function () {
      switch (this.step) {
        case 1:
          return this.phone.err
        case 2:
          return this.location.err
        case 3:
          return this.children.err
        case 4:
          return this.eventActivity.err
        case 5:
          return this.food.err
        case 6:
          return this.eventTime.err
        case 7:
          return this.eventDate.err
        case 9:
          return this.canProvideEmergencyCare.err
        case 10:
          return this.availability.err
        case 11:
          return this.hasPets.err
        case 12:
          return this.petsDescription.err
        case 13:
          return this.houseRules.err
        default:
          return false
      }
    },
    nextButtonState: function () {
      if (this.step > this.lastStep) {
        return 'none'
      } else if (this.error === 'skippable') {
        return 'skip'
      } else if (this.error) {
        return 'inactive'
      } else {
        return 'next'
      }
    },
    userRequestedCare: function () {
      if (this.bookingRequest.err === false) {
        return true
      } else return false
    },
    eventName: function () {
      if (this.currentUser.firstName) {
        return this.capitalize(this.eventActivity.selected) + ' & ' + this.food.selected + ' with ' + this.capitalize(this.currentUser.firstName)
      } else {
        return this.capitalize(this.eventActivity.selected) + ' & ' + this.food.selected
      }
    },
    eventDataForSubmissionToAPI: function () {
      return {
        'event_series': {
          'name': this.eventName,
          'start_date': this.eventDate.selected,
          'starts_at': this.eventTime.start,
          'ends_at': this.eventTime.end,
          'has_pet': this.hasPets.isTrue,
          'activity_names': [this.eventActivity.selected],
          'foods': [this.food.selected],
          'house_rules': this.houseRules.text,
          'pet_description': this.petsDescription.text,
          'maximum_children': this.maxChildren,
          'child_age_minimum': this.childAgeMinimum,
          'child_age_maximum': this.childAgeMaximum
        }
      }
    },
    ...mapGetters(['currentUser'])
  }
}

</script>

<!-- this is a giant jumble of all app styles. Would be great to separate it out -->

<style scoped>

  /* child birthdate selector */
::-webkit-datetime-edit-text { color: rgba(0, 0, 0, .3); padding: 0 0.3em; }
::-webkit-datetime-edit-month-field { color: rgba(0, 0, 0, .3); text-transform: uppercase; }
::-webkit-datetime-edit-day-field { color: rgba(0, 0, 0, .3); text-transform: uppercase;}
::-webkit-datetime-edit-year-field { color: rgba(0, 0, 0, .3); text-transform: uppercase;}
::-webkit-inner-spin-button { display: none; }
::-webkit-calendar-picker-indicator { color: rgba(0, 0, 0, .3); }

/* background color state on checkbox list items */

.body {
  background-color: #0d73c7;
}

.active-checkbox {
  background-color: #fff !important;
}

.onb-content-container {
  margin: 0 auto;
  max-width: 600px;
  min-height: 100vh;
}

textarea, input[type="text"] {
  -webkit-appearance: none;
}

html {
  -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
}

.scrolling-wrapper {
  overflow-x: auto;
}

.card {
  flex: 0 0 auto;
}

.body {
  font-family: soleil, sans-serif;
  color: #333;
  font-size: 14px;
  line-height: 20px;
}

a {
  text-decoration: none;
}

.onb-error-container {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 100%;
  min-height: 60px;
  margin-bottom: 24px;
  padding: 16px 16px 18px;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -webkit-flex-direction: column;
  -ms-flex-direction: column;
  flex-direction: column;
  -webkit-box-pack: center;
  -webkit-justify-content: center;
  -ms-flex-pack: center;
  justify-content: center;
  -webkit-box-align: start;
  -webkit-align-items: flex-start;
  -ms-flex-align: start;
  align-items: flex-start;
  background-color: #ffbebe;
  color: #c73200;
}

.onb-error-text {
  font-size: 13px;
}

.content-wrapper {
  width: 720px;
  min-height: 100vh;
  margin-right: auto;
  margin-left: auto;
  padding-top: 50px;
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

@media (max-width: 479px) {

  .content-container {
    overflow: visible;
  }
}

</style>
