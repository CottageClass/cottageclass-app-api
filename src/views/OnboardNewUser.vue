<template>
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <Nav
          :button="nextButtonState"
          @next="nextStep"
          @prev="prevStep"
          :hidePrevious="stepIndex===0"
        />
        <StyleWrapper styleIs="onboarding">
          <div class="skip-link-wrapper">
            <div v-if="showContinueButton"
                 class="skip-link"
                 @click="finishOnboarding">
              Skip to site
            </div>
          </div>
          <ErrorMessage v-if="err && this.showError" :text="err" />
          <Phone
            v-if="currentStep==='phone'"
            @pressedEnter="nextStep"
            v-model="userData.phone"
            required="true" />
          <Location
            v-if="currentStep==='location'"
            v-model="userData.location"
            @pressedEnter="nextStep"
            required="true"/>
          <FacebookImageSelection
            v-if="currentStep==='facebookImages'"
            v-model="userData.facebookImages"
            @pressedEnter="nextStep"
            v-on:noImages="nextStep"
            v-on:noPermissions="nextStep"
            required="true"/>
          <Children
            v-if="currentStep==='children'"
            v-model="userData.children" />
          <Employment
            v-if="currentStep==='employment'"
            v-model="userData.employment" />
          <YesOrNo
            v-if="currentStep==='createEventsNow'"
            v-model="createEventsNow"
            question="Would you like to set up your first playdates now or later?"
            description=""
            yesText="Now"
            noText="Later"
          />
          <EventActivity
            v-if="currentStep==='eventActivity'"
            v-model="eventSeriesData.activity" />
          <EventTime
            v-if="currentStep==='eventTime'"
            v-model="eventSeriesData.time" />
          <EventDate
            v-if="currentStep==='eventDate'"
            v-model="eventSeriesData.date" />
          <MaxChildren
            v-if="currentStep==='maxChildren'"
            v-model="eventSeriesData.maxChildren" />
          <YesOrNo
            v-if="currentStep==='emergencyCare' && substep==='canProvide'"
            v-model="userData.emergencyCare"
            question="Childcare in a Pinch?"
            description="Parents often need care at times not covered by our events. Would you like to be able to request childcare from other members when you need it and receive requests (by text message) in return?"
          />
          <Availability
            v-if="currentStep==='emergencyCare' && substep==='availability'"
            v-model="userData.emergencyCare" />
          <YesOrNo
            v-if="currentStep==='pets' && substep==='hasPets'"
            v-model="userData.pets"
            question="Do you have pets?"
            description="This is often very important for parents (and children) to know."
          />
          <PetsDescription
            v-if="currentStep==='pets' && substep==='description'"
            v-model="userData.pets" />
          <HouseRules v-if="currentStep==='houseRules'"
            v-model="userData.houseRules" />
          <ProfileBlurb
            v-if="currentStep==='profileBlurb'"
            v-model="userData.profileBlurb" />
          <LanguagesSpoken
            v-if="currentStep==='languages'"
            v-model="userData.languages" />
          <Activities
            v-if="currentStep==='activities'"
            v-model="userData.activities" />
        </StyleWrapper>
      </div>
    </div>
  </div>
</template>

<script>
import { submitEventSeriesData, submitUserInfo } from '@/utils/api'
import { mapGetters } from 'vuex'
import sheetsu from 'sheetsu-node'
import moment from 'moment'
import _ from 'lodash'

import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import Nav from '@/components/FTE/Nav.vue'
import ErrorMessage from '@/components/base/ErrorMessage.vue'

import Phone from '@/components/FTE/userInformation/Phone.vue'
import Location from '@/components/FTE/userInformation/Location.vue'
import Children from '@/components/FTE/userInformation/Children.vue'
import Employment from '@/components/FTE/userInformation/Employment'
import EventActivity from '@/components/base/eventSpecification/EventActivity.vue'
import EventTime from '@/components/base/eventSpecification/EventTime.vue'
import EventDate from '@/components/base/eventSpecification/EventDate.vue'
import MaxChildren from '@/components/base/eventSpecification/MaxChildren.vue'
import YesOrNo from '@/components/base/YesOrNo.vue'
import Availability from '@/components/FTE/userInformation/Availability.vue'
import PetsDescription from '@/components/FTE/userInformation/PetsDescription.vue'
import HouseRules from '@/components/FTE/userInformation/HouseRules.vue'
import FacebookImageSelection from '@/components/FTE/userInformation/FacebookImageSelection.vue'
import LanguagesSpoken from '@/components/FTE/userInformation/LanguagesSpoken.vue'
import Activities from '@/components/FTE/userInformation/Activities.vue'
import ProfileBlurb from '@/components/FTE/userInformation/ProfileBlurb.vue'

const stepSequence = [
  'phone',
  'location',
  'children',
  'employment',
  'facebookImages',
  'emergencyCare',
  'createEventsNow',
  'eventActivity',
  'eventTime',
  'eventDate',
  'maxChildren',
  'pets',
  'houseRules',
  'profileBlurb',
  'activities',
  'languages'
]
const FIRST_OPTIONAL_STEP_INDEX = 13

const client = sheetsu({ address: 'https://sheetsu.com/apis/v1.0su/62cd725d6088' })

export default {
  name: 'OnboardNewUser',
  props: [],
  components: {
    Availability,
    Children,
    Employment,
    ErrorMessage,
    EventActivity,
    EventDate,
    EventTime,
    FacebookImageSelection,
    HouseRules,
    Location,
    MaxChildren,
    Nav,
    PetsDescription,
    Phone,
    ProfileBlurb,
    StyleWrapper,
    YesOrNo,
    LanguagesSpoken,
    Activities
  },
  data () {
    return {
      showError: false,
      stepIndex: 0,
      substep: '',
      createEventsNow: { err: null },
      userData: {
        employment: { err: null },
        phone: { err: null },
        location: { err: null },
        children: { list: [], err: null },
        pets: { err: null },
        houseRules: { err: null },
        emergencyCare: { err: null },
        facebookImages: { err: null },
        languages: [],
        activities: [],
        profileBlurb: ''
      },
      eventSeriesData: {
        activity: { err: null },
        time: { err: null },
        date: { err: null },
        maxChildren: 2
      },
      activityAges: {
        'Arts & Crafts': [2, 11],
        'Baby playgroup': [0, 3],
        'Books & Storytime': [0, 9],
        'Drawing & Coloring': [0, 9],
        'Games & Puzzles': [3, 11],
        'Kids\' Movie Night': [3, 11],
        'Playing outside (weather permitting)': [0, 11],
        'Playground Meetup': [0, 11],
        'Waldorf Nature Walk': [0, 11]
      }
    }
  },
  computed: {
    currentStep () {
      return stepSequence[this.stepIndex]
    },
    nextButtonState () {
      if (!this.modelForCurrentStep) {
        return 'inactive'
      }
      if (this.modelForCurrentStep.err) {
        return 'inactive'
      } else {
        return 'next'
      }
    },
    modelForCurrentStep () {
      const models = {
        phone: this.userData.phone,
        location: this.userData.location,
        children: this.userData.children,
        houseRules: this.userData.houseRules,
        emergencyCare: this.userData.emergencyCare,
        employment: this.userData.employment,
        pets: this.userData.pets,
        facebookImages: this.userData.facebookImages,
        createEventsNow: this.createEventsNow,
        eventActivity: this.eventSeriesData.activity,
        eventTime: this.eventSeriesData.time,
        eventDate: this.eventSeriesData.date,
        maxChildren: this.eventSeriesData.maxChildren,
        languages: this.userData.languages,
        activities: this.userData.activities,
        profileBlurb: this.userData.profileBlurb
      }
      return models[this.currentStep]
    },
    err () {
      return this.modelForCurrentStep && this.modelForCurrentStep.err
    },
    eventName: function () {
      if (this.currentUser.firstName) {
        return this.capitalize(this.eventSeriesData.activity.selected) + ' with ' + this.capitalize(this.currentUser.firstName)
      } else {
        return this.capitalize(this.eventSeriesData.activity.selected)
      }
    },
    eventDataForSubmissionToAPI: function () {
      // TODO move this function out of the component and into api or a helper
      return {
        'event_series': {
          'name': this.eventName,
          'start_date': this.eventSeriesData.date.selected,
          'starts_at': this.eventSeriesData.time.start,
          'ends_at': this.eventSeriesData.time.end,
          'has_pet': typeof this.userData.pets.text !== 'undefined' &&
              this.userData.pets.text.length > 0,
          'activity_names': [this.eventSeriesData.activity.selected],
          'house_rules': this.userData.houseRules.text,
          'pet_description': this.userData.pets.text,
          'maximum_children': this.eventSeriesData.maxChildren,
          'child_age_minimum': this.childAgeMinimum,
          'child_age_maximum': this.childAgeMaximum
        }
      }
    },
    childAgeMinimum () {
      if (this.eventSeriesData.activity.selected) {
        return this.activityAges[this.eventSeriesData.activity.selected][0]
      }
      return 2
    },
    childAgeMaximum () {
      if (this.eventSeriesData.activity.selected) {
        return this.activityAges[this.eventSeriesData.activity.selected][1]
      }
      return 11
    },
    showContinueButton () {
      return (this.stepIndex >= FIRST_OPTIONAL_STEP_INDEX)
    },
    ...mapGetters([ 'currentUser', 'redirectRoute', 'firstCreatedEvent' ])
  },
  methods: {
    submitEventData: function () {
      if (this.createEventsNow.isTrue) {
        return submitEventSeriesData(this.eventDataForSubmissionToAPI)
      } else {
        return null
      }
    },
    submitUserData (all = false) {
      const userId = this.currentUser.id
      let submission
      if (all) {
        submission = submitUserInfo(
          userId, {
            images: this.userData.facebookImages,
            phone: this.userData.phone,
            location: this.userData.location,
            availability: this.userData.emergencyCare,
            children: this.userData.children,
            jobPosition: this.userData.employment.jobPosition,
            employer: this.userData.employment.employer,
            profileBlurb: this.userData.profileBlurb,
            activities: this.userData.activities,
            languages: this.userData.languages
          }
        )
      } else {
        let params = {}
        switch (this.currentStep) {
          case 'employment':
            _.assign(params, {
              employer: this.userData.employment.employer,
              jobPosition: this.userData.employment.jobPosition
            })
            break
          case 'facebookImages':
            _.assign(params, { images: this.userData.facebookImages })
            break
          case 'activities':
            _.assign(params, { activities: this.userData.activities })
            break
          case 'profileBlurb':
            _.assign(params, { profileBlurb: this.userData.profileBlurb })
            break
          case 'languages':
            _.assign(params, { languages: this.userData.languages })
            break
          case 'phone':
            _.assign(params, { phone: this.userData.phone })
            break
          case 'location':
            _.assign(params, { location: this.userData.location })
            break
          case 'children':
            _.assign(params, { children: this.userData.children.list })
            break
          case 'emergencyCare':
            _.assign(params, { availability: this.userData.emergencyCare })
            break
          default:
            return // no data to submit
        }
        submission = submitUserInfo(userId, params)
      }
      return submission.catch(function (err) {
        console.log('user update FAILURE')
        console.log(err)
        this.stepIndex = stepSequence.length - 1
        this.modelForCurrentStep.err = 'Sorry, there was a problem saving your information. Try again?'
        throw err
      })
    },
    async finishOnboarding () {
      // send the data to the server
      const userId = this.currentUser.id
      try {
        await this.submitUserData(true)
        await this.$store.dispatch('updateCurrentUserFromServer')
        const eventData = await this.submitEventData()
        this.$store.commit('setCreatedEvents', { eventData: eventData })
        this.log('event creation SUCCESS')
        this.moveOntoNextFTE()

        const that = this
        // sheetsu update
        client.create({
          'ID': userId,
          'Date joined': moment(Date()).format('L'),
          'address': this.userData.location.fullAddress,
          'phone': this.userData.phone.number,
          'children': this.userData.children.list,
          'availability': this.userData.availability
        }, 'newUsers').then(function (data) {
          that.log(data)
        }, function (err) {
          that.logError(err)
        })
      } catch (e) {
        this.logError(e)
        this.stepIndex = stepSequence.length - 1
        this.modelForCurrentStep.err = 'Sorry, there was a problem saving your information. Try again?'
        throw e
      }
    },
    moveOntoNextFTE () {
      if (this.redirectRoute) {
        this.$router.push(this.redirectRoute)
      } else {
        if (this.firstCreatedEvent) {
          this.$router.push({ name: 'SocialInvite', params: { id: this.firstCreatedEvent.id } })
        } else {
          // in the case that the event creation was skipped, we go straight to home
          this.$router.push({ name: 'Events' })
        }
      }
    },
    nextStep () {
      if (!this.err) {
        if (this.stepIndex === stepSequence.length - 1) {
          this.finishOnboarding()
        } else {
          if (this.currentStep === 'location') {
            this.$store.commit('setMapArea', {
              center: { lat: this.userData.location.lat, lng: this.userData.location.lng },
              maxDistance: 5
            })
          }
          this.submitUserData()
        }
        // set the next step
        if (this.currentStep === 'pets' &&
            this.substep === 'hasPets' &&
            this.userData.pets.isTrue) {
          this.substep = 'description'
        } else if (this.currentStep === 'emergencyCare' && this.substep === 'canProvide' && this.userData.emergencyCare.isTrue) {
          this.substep = 'availability'
        } else if (this.currentStep === 'createEventsNow' && !this.createEventsNow.isTrue) {
          // skip event creation
          this.stepIndex = FIRST_OPTIONAL_STEP_INDEX
        } else {
          this.$ga.event('onboarding', 'stepComplete', this.currentStep)
          this.stepIndex += 1
          if (this.currentStep === 'pets') {
            this.substep = 'hasPets'
          } else if (this.currentStep === 'emergencyCare') {
            this.substep = 'canProvide'
          } else if (this.currentStep === 'facebookImages' && !this.currentUser.facebookUid) {
            // not logged in via facebook, skip this step
            this.nextStep()
          }
        }
        this.showError = false
        window.scrollTo(0, 0)
      } else {
        this.showError = true
      }
    },
    prevStep () {
      if (this.currentStep === 'pets' && this.substep === 'description') {
        this.substep = 'hasPets'
        this.modelForCurrentStep.err = false
      } else if (this.currentStep === 'emergencyCare' && this.substep === 'availability') {
        this.substep = 'canProvide'
        this.modelForCurrentStep.err = false
      } else {
        this.stepIndex -= 1
        if (this.currentStep === 'pets') {
          if (this.userData.pets.isTrue) {
            this.substep = 'description'
          } else {
            this.substep = 'hasPets'
          }
        }
        if (this.currentStep === 'emergencyCare') {
          if (this.userData.emergencyCare.isTrue) {
            this.substep = 'availability'
          } else {
            this.substep = 'canProvide'
          }
        }
        if (this.currentStep === 'facebookImages' && !this.currentUser.facebookUid) {
          this.prevStep()
        }
      }
      window.scrollTo(0, 0)
    },
    capitalize: function (string) {
      return string.charAt(0).toUpperCase() + string.slice(1)
    }
  }
}
</script>

<style>
.skip-link-wrapper {
  display: flex;
  justify-content:center;
}
.skip-link {
  margin-top: 47px;
  color: hsla(0, 0%, 100%, .6);
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

.body {
  background-color: #0d73c7;
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
