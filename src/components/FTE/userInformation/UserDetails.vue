<template>
  <div>
    <Nav
      :button="nextButtonState"
      @next="nextStep"
      @prev="prevStep"
      :hidePrevious="stepIndex===0"
    />
    <ErrorMessage v-if="errorMessage && this.showError" :text="errorMessage" />
    <div class="skip-link-wrapper">
      <div class="skip-link"
           @click="$emit('finished')">
        Skip to site
      </div>
    </div>
    <ProfileBlurb
      v-if="stepName==='profile'"
      v-model="profileBlurb" />
    <LanguagesSpoken
      v-if="stepName==='languages'"
      v-model="languages" />
    <Activities
      v-if="stepName==='activities'"
      v-model="activities" />
  </div>
</template>

<script>
import Nav from '@/components/FTE/Nav'
import ErrorMessage from '@/components/base/ErrorMessage.vue'

import { submitUserInfo } from '@/utils/api'
import { mapGetters } from 'vuex'
import { } from '@/mixins'

import LanguagesSpoken from '@/components/FTE/userInformation/LanguagesSpoken.vue'
import Activities from '@/components/FTE/userInformation/Activities.vue'
import ProfileBlurb from '@/components/FTE/userInformation/ProfileBlurb.vue'

const stepSequence = [
  'profile',
  'languages',
  'activities'
]

export default {
  name: 'UserDetails',
  props: ['stepName'],
  components: { Nav, ErrorMessage, ProfileBlurb, Activities, LanguagesSpoken },
  mixins: [],
  data () {
    return {
      profileBlurb: '',
      languages: [],
      activities: [],
      showError: false
    }
  },
  computed: {
    modelForCurrentStep () {
      const models = {
        profileBlurb: this.profileBlurb,
        activities: this.activities,
        languages: this.languages
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
      return stepSequence.findIndex(s => s === this.stepName)
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    submitUserData () {
      let params = {}
      const userId = this.currentUser.id
      switch (this.stepName) {
        case 'profile' :
          params = { profileBlurb: this.profileBlurb }
          break
        case 'languages':
          params = { languages: this.languages }
          break
        case 'activities':
          params = { activities: this.activities }
          break
        default:
          return // no data to submit
      }
      try {
        submitUserInfo(userId, params)
      } catch (e) {
        console.log('user update FAILURE')
        console.log(e)
        this.stepIndex = stepSequence.length - 1
        this.modelForCurrentStep.err = 'Sorry, there was a problem saving your information. Try again?'
      }
    },
    nextStep () {
      if (!this.errorMessage) {
        if (this.stepIndex === stepSequence.length - 1) {
          this.$emit('finished')
        } else {
          this.submitUserData()
          this.$ga.event('onboarding', 'stepComplete', this.stepName)
          this.$router.push({
            params: { stepName: stepSequence[this.stepIndex + 1] }
          })
          this.showError = false
          window.scrollTo(0, 0)
        }
      } else {
        this.showError = true
      }
    },
    prevStep () {
      this.$router.push({ params: {
        stepName: stepSequence[this.stepIndex - 1]
      } })
      window.scrollTo(0, 0)
    }
  },
  created () {
    if (!this.stepName) {
      this.$router.replace({ params: { stepName: stepSequence[0] } })
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
  cursor: pointer;
}

</style>
