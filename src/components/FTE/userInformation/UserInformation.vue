<template>
  <div>
    <Phone
      v-if="stepName==='phone'"
      @pressedEnter="nextStep"
      v-model="phone"
      required="true" />
    <Location
      v-if="stepName==='location'"
      v-model="place"
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
      v-model="images"
      @pressedEnter="nextStep"
      v-on:noImages="nextStep"
      v-on:noPermissions="nextStep"
      required="true"/>
    <ProfileBlurb
      v-if="stepName==='bio'"
      v-model="profileBlurb" />
    <MaxDistanceSetting
      v-if="stepName==='distance'"
      v-model="maxDistance" />
    <AvatarUpload
      :facebookUid="this.currentUser.facebookUid"
      v-if="stepName==='avatar'"
      v-model="avatar" />
    <Availability
      v-if="stepName==='availability'"
      v-model="availability" />
  </div>
</template>

<script>
import normalize from 'json-api-normalizer'
import { mapGetters, mapMutations, mapActions } from 'vuex'

import Availability from '@/components/FTE/userInformation/Availability.vue'
import Phone from '@/components/FTE/userInformation/Phone.vue'
import Location from '@/components/FTE/userInformation/Location.vue'
import Children from '@/components/FTE/userInformation/Children.vue'
import Employment from '@/components/FTE/userInformation/Employment'
import FacebookImageSelection from '@/components/FTE/userInformation/FacebookImageSelection.vue'
import ProfileBlurb from '@/components/FTE/userInformation/ProfileBlurb.vue'
import MaxDistanceSetting from '@/components/FTE/userInformation/MaxDistanceSetting'
import AvatarUpload from '@/components/FTE/userInformation/AvatarUpload'

import { createUser } from '@/utils//createUser'
import { submitUserInfo } from '@/utils/api'
import { stepNavigation } from '@/mixins'

export default {
  name: 'UserInformation',
  props: ['stepName'],
  components: {
    Phone,
    Location,
    Children,
    Employment,
    FacebookImageSelection,
    ProfileBlurb,
    MaxDistanceSetting,
    AvatarUpload,
    Availability
  },
  mixins: [stepNavigation],
  data () {
    return {
      availability: {},
      context: 'onboarding',
      phone: { err: null },
      place: { err: null },
      children: { err: null },
      employment: { err: null },
      images: { err: null },
      profileBlurb: { err: null },
      maxDistance: { err: null },
      avatar: { err: null },
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
        'distance',
        'avatar',
        'availability',
        'images'
      ]
    },
    modelForCurrentStep () {
      const models = {
        bio: this.profileBlurb,
        phone: this.phone,
        location: this.place,
        children: this.children,
        employment: this.employment,
        images: this.images,
        distance: this.maxDistance,
        avatar: this.avatar,
        availability: this.availability
      }
      return models[this.stepName]
    },
    ...mapGetters(['currentUser'])
  },
  created () {
    this.$emit('set-nav-props', {
      nextButtonHandler: this.nextStep,
      prevButtonHandler: this.prevStep

    })
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
        case 'images':
          params = { images: this.images.state }
          break
        case 'phone':
          params = { phone: this.phone }
          break
        case 'location':
          params = { place: this.place }
          break
        case 'children':
          params = { children: this.children.list }
          break
        case 'distance':
          params = { settingMaxDistance: this.maxDistance }
          break
        case 'avatar':
          params = { avatar: this.avatar.avatar }
          break
        case 'availability':
          params = { availability: this.availability }
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
      if (!this.validationError) {
        if (this.stepName === 'images') {
          this.submitUserData()
        }
        if (this.stepName === this.stepSequence[this.stepSequence.length - 1]) {
          this.$emit('finished')
        } else {
          if (this.stepName === 'location') {
            this.setMapArea({
              center: this.place.latlng,
              maxDistance: 5
            })
          }
          if (this.stepName === 'distance') {
            this.setMapArea({
              maxDistance: this.maxDistance
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
    ...mapMutations([ 'setCurrentUser' ]),
    ...mapActions([ 'setMapArea' ])
  },
  watch: {
    stepIndex: {
      handler: function () {
        this.$emit('set-nav-props', {
          hidePrevious: this.stepIndex === 0
        })
      },
      immediate: true
    }
  }
}
</script>

<style scoped>

</style>
