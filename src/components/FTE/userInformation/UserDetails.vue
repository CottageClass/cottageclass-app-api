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
    <Availability
      v-if="stepName==='availability'"
      v-model=availability />
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
import { stepNavigation } from '@/mixins'

import Activities from '@/components/FTE/userInformation/Activities.vue'
import Availability from '@/components/FTE/userInformation/Availability.vue'

export default {
  name: 'UserDetails',
  props: ['stepName'],
  components: { Nav, ErrorMessage, Activities, Availability },
  mixins: [stepNavigation],
  data () {
    return {
      context: 'onboarding',
      availability: {},
      activities: [],
      showError: false
    }
  },
  computed: {
    nextButtonState () {
      // override the mixin method
      if (this.errorMessage) {
        return 'inactive'
      } else if (this.stepName === 'availability' && !Object.values(this.availability).some(v => v)) {
        return 'skip'
      } else {
        return 'next'
      }
    },
    stepSequence () {
      return [
        'availability',
        'activities'
      ]
    },
    modelForCurrentStep () {
      const models = {
        availability: this.availability,
        activities: this.activities
      }
      return models[this.stepName]
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    submitUserData () {
      let params = {}
      const userId = this.currentUser.id
      switch (this.stepName) {
        case 'availability':
          params = { availability: this.availability }
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
        this.stepIndex = this.stepSequence.length - 1
        this.modelForCurrentStep.err = 'Sorry, there was a problem saving your information. Try again?'
      }
    },
    nextStep () {
      if (!this.errorMessage) {
        this.submitUserData()
        this.trackStep('user-details')
        if (this.stepIndex === this.stepSequence.length - 1) {
          this.$emit('finished')
        } else {
          this.$router.push({
            params: { stepName: this.stepSequence[this.stepIndex + 1] }
          })
          this.showError = false
          window.scrollTo(0, 0)
        }
      } else {
        this.showError = true
      }
    },
    prevStep () {
      this.$router.replace({ params: {
        stepName: this.stepSequence[this.stepIndex - 1]
      } })
      window.scrollTo(0, 0)
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
