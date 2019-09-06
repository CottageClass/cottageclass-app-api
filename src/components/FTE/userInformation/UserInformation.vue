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
    <ProfileBlurb
      v-if="stepName==='bio'"
      v-model="profileBlurb" />
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
import ProfileBlurb from '@/components/FTE/userInformation/ProfileBlurb.vue'

import normalize from 'json-api-normalizer'
import { createUser } from '@/utils//createUser'
import { submitUserInfo } from '@/utils/api'
import { mapGetters, mapMutations } from 'vuex'
import { stepNavigation } from '@/mixins'
export default {
  name: 'UserInformation',
  props: ['stepName'],
  components: { Nav, Phone, Location, Children, Employment, FacebookImageSelection, ErrorMessage, ProfileBlurb },
  mixins: [stepNavigation],
  data () {
    return {
      context: 'onboarding',
      phone: { err: null },
      location: { err: null },
      children: { err: null },
      employment: { err: null },
      facebookImages: { err: null },
      profileBlurb: { err: null },
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
        'bio',
        'images'
      ]
    },
    modelForCurrentStep () {
      const models = {
        bio: this.profileBlurb,
        phone: this.phone,
        location: this.location,
        children: this.children,
        employment: this.employment,
        images: this.images
      }
      return models[this.stepName]
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    async submitUserData () {
      let params = {}
      const userId = this.currentUser.id
      switch (this.stepName) {
        case 'bio' :
          params = { profileBlurb: this.profileBlurb.text }
          break
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
        const res = await submitUserInfo(userId, params)
        this.setCurrentUser({ user: createUser(normalize(res.data)) })
      } catch (e) {
        console.log('user update FAILURE')
        console.log(e)
        this.stepIndex = this.stepSequence.length - 1
        this.modelForCurrentStep.err = 'Sorry, there was a problem saving your information. Try again?'
      }
    },
    nextStep () {
      if (!this.errorMessage) {
        if (this.stepName === this.stepSequence[this.stepSequence.length - 1]) {
          this.$emit('finished')
        } else {
          if (this.stepName === 'location') {
            this.$store.commit('setMapArea', {
              center: { lat: this.location.lat, lng: this.location.lng },
              maxDistance: 5
            })
          }
          this.submitUserData()
          this.trackStep('user-info')

          const nextStepName = this.stepSequence[this.stepIndex + 1]

          if (nextStepName === 'images' && !this.currentUser.facebookUid) {
            this.$emit('finished')
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
    },
    ...mapMutations([ 'setCurrentUser' ])
  }
}
</script>

<style scoped>

</style>
