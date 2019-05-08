<template>
<div class="body" id="top-of-form">
  <MainNav />
  <div class="lp-container w-container">
  <h1 class="heading-1">Edit profile</h1>
  <StyleWrapper styleIs="editing" class="cards" v-if="currentUser">
      <ErrorMessage v-if="showError && hasError" text="Your form has errors. Please fix them to continue..." />
      <ErrorMessage v-if="showError && hasError && phone.err" :text="phone.err" />
      <ErrorMessage v-if="showError && hasError && employment.err" :text="employment.err" />
    <Phone v-model="phone" :currentPhone="currentUser.phone" :required="false" />
    <ErrorMessage v-if="showError" :text="location.err" />
    <Location
      :currentAddress="currentUser.fullAddress"
      :currentApartment="currentUser.apartmentNumber"
      v-model="location"
      />
    <Employment v-model="employment"/>
    <ProfileBlurb v-model="currentUser.profileBlurb" />
    <Question
      title="Got any photos you'd like to share?"
      subtitle="Adding photos to your profile helps give other members a sense of your family."
      >
      <MultipleImageUpload v-model="currentUser.images" />
    </Question>
    <Activities v-model="currentUser.activities" />
    <Availability v-model="availability" :required="false"/>
    <ErrorMessage v-if="showError" :text="children.err" />
    <Children v-model="children" :required="false" />
    <LanguagesSpoken v-model="currentUser.languages"/>
    <div class="save-button-container">
      <div v-if="!isMobile"
        class="save-button w-button"
        @click="submitUserInformation">{{saveButtonText}}</div>
    </div>
  </StyleWrapper>
  <PageActionsFooter v-if="isMobile" :buttons="footerButtons" @primary-click="submitUserInformation" />
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
import * as api from '@/utils/api.js'
import { redirect, screen } from '@/mixins'
import { mapGetters } from 'vuex'

var VueScrollTo = require('vue-scrollto')

export default {
  name: 'ProfileEdit',
  mixins: [redirect, screen],
  components: {
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
    Activities
  },
  data () {
    return {
      location: {},
      phone: {},
      employment: {},
      availability: {},
      showError: false,
      saveButtonText: 'Save',
      children: null
    }
  },
  created: function () {
    if (this.redirectToSignupIfNotAuthenticated()) { return }
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
      this.$router.push({ name: 'ProviderProfile', params: { id: this.currentUser.id } })
    },
    submitUserInformation: async function () {
      if (!this.hasError) {
        this.saveButtonText = 'Saving...'
        let data = Object.assign(this.currentUser, this.employment, {})
        data.children = this.children.list
        const { phone, location, availability } = this
        data = Object.assign(data, { phone, location, availability })
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
  }
}
</script>

<style scoped>

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
