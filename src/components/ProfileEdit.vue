<template>
  <div class="body" id="top-of-form">
    <MainNav />
    <div class="lp-container w-container">
      <h1 class="heading-1">Edit profile</h1>
      <StyleWrapper styleIs="editing" class="cards" v-if="currentUser">
        <ErrorMessage v-if="showError && hasError" text="Your form has errors. Please fix them to continue..." />
        <ErrorMessage v-if="showError && hasError && phone.err" :text="phone.err" />
        <ErrorMessage v-if="showError && hasError && employment.err" :text="employment.err" />
        <ErrorMessage v-if="showError" :text="location.err" />
        <ErrorMessage v-if="showError" :text="children.err" />
        <ErrorMessage v-if="showError" :text="avatar.err" />
        <Question
          title="Got any photos you'd like to share?"
          subtitle="Adding photos to your profile helps give other members a sense of your family."
        >
          <MultipleImageUpload v-model="currentUser.images" />
        </Question>
        <AvatarUpload v-model="avatar"/>
        <Employment v-model="employment"/>
        <ProfileBlurb v-model="profileBlurb" />
        <Activities v-model="currentUser.activities" />
        <Availability id="availability" v-model="availability" :required="false"/>
        <Children v-model="children" :required="false" />
        <Phone v-model="phone" :currentPhone="currentUser.phone" :required="false" />
        <Location
          :currentAddress="currentUser.fullAddress"
          :currentApartment="currentUser.apartmentNumber"
          v-model="location"
        />
        <LanguagesSpoken v-model="currentUser.languages" :showChoicesImmediately="false"/>
        <MaxDistanceSetting v-model="maxDistance" />
        <YesOrNo
          question="Email settings"
          description="Would you like to receive custom weekly emails with suggestions for nearby playdates"
          v-model="weeklyEmails"
        />
        <Question title="Delete your account"
                  subtitle="Would you like to leave Lilypad? Deleting your account will remove your profile and cancel any playdates you've booked. This cannot be undone.">
          <button
            class="delete-account-button"
            @click="$router.push({name: 'DeleteAccountConfirmation'})">
            Delete Account
          </button>
        </Question>
      </StyleWrapper>
      <PageActionsFooter :buttons="footerButtons" @primary-click="submitUserInformation" />
    </div>
  </div>

</template>

<script>
import Question from '@/components/base/Question.vue'
import MultipleImageUpload from '@/components/base/MultipleImageUpload.vue'
import Location from '@/components/FTE/userInformation/Location.vue'
import ProfileBlurb from '@/components/FTE/userInformation/ProfileBlurb.vue'
import Employment from '@/components/FTE/userInformation/Employment.vue'
import LanguagesSpoken from '@/components/FTE/userInformation/LanguagesSpoken.vue'
import Children from '@/components/FTE/userInformation/Children.vue'
import Phone from '@/components/FTE/userInformation/Phone.vue'
import Availability from '@/components/FTE/userInformation/Availability.vue'
import MainNav from '@/components/MainNav.vue'
import PageActionsFooter from '@/components/PageActionsFooter.vue'
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import Activities from '@/components/FTE/userInformation/Activities.vue'
import YesOrNo from '@/components/base/YesOrNo'
import MaxDistanceSetting from '@/components/FTE/userInformation/MaxDistanceSetting'
import AvatarUpload from '@/components/FTE/userInformation/AvatarUpload'

import * as api from '@/utils/api'
import { redirect, screen } from '@/mixins'
import { mapGetters } from 'vuex'

var VueScrollTo = require('vue-scrollto')

export default {
  name: 'ProfileEdit',
  mixins: [redirect, screen],
  components: {
    AvatarUpload,
    Location,
    Phone,
    Employment,
    Availability,
    MainNav,
    StyleWrapper,
    PageActionsFooter,
    ErrorMessage,
    Children,
    Question,
    MultipleImageUpload,
    ProfileBlurb,
    LanguagesSpoken,
    Activities,
    YesOrNo,
    MaxDistanceSetting
  },
  data () {
    return {
      avatar: {},
      weeklyEmails: {},
      maxDistance: {},
      location: {},
      phone: {},
      employment: {},
      availability: {},
      profileBlurb: {},
      showError: false,
      saveButtonText: 'Save',
      children: null
    }
  },
  created: function () {
    if (this.redirectToSignupIfNotAuthenticated()) { return }
    this.avatar = { avatar: this.currentUser.avatar, err: null }
    this.weeklyEmails = { isTrue: this.currentUser.settingEmailNotifications }
    this.maxDistance = this.currentUser.settingMaxDistance || '2'
    this.availability = {
      availableAfternoons: !!this.currentUser.availableAfternoons,
      availableMornings: !!this.currentUser.availableMornings,
      availableEvenings: !!this.currentUser.availableEvenings,
      availableWeekends: !!this.currentUser.availableWeekends
    }
    this.children = { 'list': this.currentUser.children || [] }
    this.employment = {
      jobPosition: this.currentUser.jobPosition,
      employer: this.currentUser.employer,
      err: null
    }
    this.profileBlurb = {
      text: this.currentUser.profileBlurb,
      err: null
    }
  },
  computed: {
    hasError: function () {
      if (!!this.phone.err || !!this.location.err || !!this.children.err || this.employment.err) {
        return true
      } else {
        return false
      }
    },
    footerButtons () {
      return [{
        text: this.saveButtonText
      }]
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    toToProfilePage () {
      this.$router.push({ name: 'UserPage', params: { id: this.currentUser.id } })
    },
    submitUserInformation: async function () {
      if (!this.hasError) {
        this.saveButtonText = 'Saving...'
        let data = Object.assign(this.currentUser, this.employment, {})
        data.children = this.children.list
        data.profileBlurb = this.profileBlurb.text
        data.avatar = this.avatar.avatar
        const settingMaxDistance = this.maxDistance
        const settingEmailNotifications = this.weeklyEmails.isTrue
        const { phone, location, availability } = this
        data = Object.assign(data, { phone, location, availability, settingEmailNotifications, settingMaxDistance })
        try {
          const res = await api.submitUserInfo(this.currentUser.id, data)
          this.saveButtonText = ' \u2714 Saved'
          this.$store.dispatch('updateCurrentUserFromServer')
          this.toToProfilePage()
          this.log('user update SUCCESS')
          this.log(res)
        } catch (e) {
          this.logError('Error saving')
          this.logError(e)
          this.saveButtonText = 'Problem saving. Click to try again.'
        }
      } else {
        this.showError = true
        VueScrollTo.scrollTo('#top-of-form')
      }
    }
  },
  watch: {
    avatar: {
      async handler (newValue, oldValue) {
        if (newValue.avatar !== this.currentUser.avatar) {
          this.debug({ newValue })
          try {
            const res = await api.submitUserInfo(this.currentUser.id, { avatar: this.avatar.avatar })
            this.$store.dispatch('updateCurrentUserFromServer')
            this.log('user update SUCCESS')
            this.log(res)
          } catch (e) {
            this.logError('Error saving')
            this.logError(e)
          }
        }
      }
    }
  }
}
</script>

<style scoped>

.delete-account-button {
  padding: 12px 32px;
  border-radius: 4px;
  background-color: #e91f29;
  text-align: center;
  color: #fff;
}

.delete-account-button:hover {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
}

.delete-account-button:active {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
}

.save-button-container {
  margin-top:12px;
  width: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  & .save-button {
    min-width: 160px;
    margin-left: auto;
    margin-right: auto;
    padding: 12px;
    border-radius: 4px;
    text-align: center;
  }
}

.body {
  font-family: soleil;
  color: #333;
  font-size: 14px;
  line-height: 20px;
  background-color: #f5f5f5;
}

.heading-1 {
  margin-bottom: 32px;
}

.lp-container {
  padding: 32px 32px 100px;
}

@media (max-width: 991px) {
  .body {
    padding-bottom: 77px;
  }

  .lp-container {
    padding-bottom: 32px;
  }
}

@media (max-width: 767px) {
  .body {
    padding-bottom: 50px;
  }

  .heading-1 {
    margin-right: 24px;
    margin-left: 24px;
  }

  .lp-container {
    padding-top: 16px;
    padding-right: 0px;
    padding-left: 0px;
  }
}

@media (max-width: 479px) {
  .heading-1 {
    font-size: 34px;
    line-height: 44px;
  }
}

</style>
