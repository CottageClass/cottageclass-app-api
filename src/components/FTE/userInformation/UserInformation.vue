<template>
  <div>
    <Nav
      :button="nextButtonState"
      @next="nextStep"
      @prev="prevStep"
      :hidePrevious="stepIndex===0"
    />
    <ErrorMessage v-if="errorMessage && this.showError" :text="errorMessage" />
    <Phone
      v-if="stepName==='phone'"
      @pressedEnter="nextStep"
      v-model="phone"
      required="true" />
    <Location
      v-if="stepName==='location'"
      v-model="location"
      @pressedEnter="nextStep"
      required="true"/>
    <Children
      v-if="stepName==='children'"
      v-model="children" />
    <Employment
      v-if="stepName==='employment'"
      v-model="employment" />
    <FacebookImageSelection
      v-if="stepName==='images'"
      v-model="facebookImages"
      @pressedEnter="nextStep"
      v-on:noImages="nextStep"
      v-on:noPermissions="nextStep"
      required="true"/>
    <YesOrNo
      v-if="stepName==='offer-now'"
      v-model="offerNow"
      question="Would you like to set up your first playdates now or later?"
      description=""
      yesText="Now"
      noText="Later"
    />
  </div>
</template>

<script>
import Nav from '@/components/FTE/Nav'
import Phone from '@/components/FTE/userInformation/Phone.vue'
import Location from '@/components/FTE/userInformation/Location.vue'
import Children from '@/components/FTE/userInformation/Children.vue'
import Employment from '@/components/FTE/userInformation/Employment'
import FacebookImageSelection from '@/components/FTE/userInformation/FacebookImageSelection.vue'
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import YesOrNo from '@/components/base/YesOrNo'

import { submitUserInfo } from '@/utils/api'
import { mapGetters } from 'vuex'
import { stepNavigation } from '@/mixins'

export default {
  name: 'UserInformation',
  props: ['stepName'],
  components: { Nav, Phone, Location, Children, Employment, FacebookImageSelection, ErrorMessage, YesOrNo },
  mixins: [stepNavigation],
  data () {
    return {
      phone: { err: null },
      location: { err: null },
      children: { err: null },
      employment: { err: null },
      facebookImages: { err: null },
      offerNow: { err: null },
      showError: false
    }
  },
  computed: {
    stepSequence () {
      return [
        'phone',
        'location',
        'children',
        'employment',
        'images',
        'offer-now'
      ]
    },
    modelForCurrentStep () {
      const models = {
        phone: this.phone,
        location: this.location,
        children: this.children,
        employment: this.employment,
        images: this.images,
        'offer-now': this.offerNow
      }
      return models[this.stepName]
    },
    errorMessage () {
      return this.modelForCurrentStep && this.modelForCurrentStep.err
    },
    nextButtonState () {
      if (this.errorMessage) {
        return 'inactive'
      } else {
        return 'next'
      }
    },
    stepIndex () {
      return this.stepSequence.findIndex(s => s === this.stepName)
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    submitUserData () {
      let params = {}
      const userId = this.currentUser.id
      switch (this.stepName) {
        case 'employment':
          params = {
            employer: this.employment.employer,
            jobPosition: this.employment.jobPosition
          }
          break
        case 'houseRules' :
          params = { houseRules: this.houseRules.text }
          break
        case 'images':
          params = { images: this.images }
          break
        case 'phone':
          params = { phone: this.phone }
          break
        case 'location':
          params = { location: this.location }
          break
        case 'children':
          params = { children: this.children.list }
          break
        default:
          return // no data to submit
      }
      try {
        submitUserInfo(userId, params)
      } catch (e) {
        console.log('user update FAILURE')
        console.log(e)
        this.stepIndex = this.stepSequence.length - 1
        this.modelForCurrentStep.err = 'Sorry, there was a problem saving your information. Try again?'
      }
    },
    nextStep () {
      if (!this.errorMessage) {
        if (this.stepName === 'offer-now') {
          this.$emit('finished', { offerNow: this.offerNow.isTrue })
        } else {
          if (this.stepName === 'location') {
            this.$store.commit('setMapArea', {
              center: { lat: this.location.lat, lng: this.location.lng },
              maxDistance: 5
            })
          }
          this.submitUserData()
          this.$ga.event('onboarding', 'stepComplete', this.stepName)

          const nextStepName = this.stepSequence[this.stepIndex + 1]

          if (nextStepName === 'images' && !this.currentUser.facebookUid) {
            this.$router.push({
              params: { stepName: this.stepSequence[this.stepIndex + 2] }
            })
          } else {
            this.$router.push({
              params: { stepName: this.stepSequence[this.stepIndex + 1] }
            })
          }
          this.showError = false
          window.scrollTo(0, 0)
        }
      } else {
        this.showError = true
      }
    },
    prevStep () {
      const params = {
        section: 'user-info',
        stepName: this.stepSequence[this.stepIndex - 1]
      }
      this.$router.push({
        name: this.$route.name,
        params
      })
      if (this.stepName === 'facebookImages' && !this.currentUser.facebookUid) {
        this.prevStep()
      }
      window.scrollTo(0, 0)
    }
  }
}
</script>

<style scoped>

</style>
