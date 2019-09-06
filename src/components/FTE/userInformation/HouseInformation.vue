<template>
  <div>
    <Nav
      :button="nextButtonState"
      @next="nextStep"
      @prev="prevStep"
      :hidePrevious="stepIndex===0"
    />
    <ErrorMessage v-if="errorMessage && this.showError" :text="errorMessage" />
    <YesOrNo
      v-if="stepName==='has-pets'"
      v-model="hasPets"
      question="Do you have pets?"
      description="This is often very important for parents (and children) to know."
    />
    <PetsDescription
      v-if="stepName==='pet-description'"
      v-model="petsDescription" />
    <HouseRules v-if="stepName==='house-rules'"
                v-model="houseRules" />
  </div>
</template>

<script>
import Nav from '@/components/FTE/Nav'
import ErrorMessage from '@/components/base/ErrorMessage.vue'

import { submitUserInfo } from '@/utils/api'
import { mapGetters } from 'vuex'
import { stepNavigation } from '@/mixins'
import YesOrNo from '@/components/base/YesOrNo.vue'
import PetsDescription from '@/components/FTE/userInformation/PetsDescription.vue'
import HouseRules from '@/components/FTE/userInformation/HouseRules.vue'

export default {
  name: 'HouseInformation',
  props: ['stepName', 'context'],
  components: { Nav, ErrorMessage, YesOrNo, PetsDescription, HouseRules },
  mixins: [stepNavigation],
  data () {
    return {
      petsDescription: { err: null },
      hasPets: { err: null },
      houseRules: { err: null },
      showError: false
    }
  },
  computed: {
    stepSequence () {
      return [
        'has-pets',
        'pet-description',
        'house-rules'
      ]
    },
    modelForCurrentStep () {
      const models = {
        'pet-description': this.petsDescription,
        'has-pets': this.hasPets,
        'house-rules': this.houseRules
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
        case 'pet-description' :
          params = { petsDescription: this.petsDescription.text,
            hasPet: typeof this.petsDescription.text !== 'undefined' &&
            this.petsDescription.text.length > 0 }
          break
        case 'house-rules':
          params = { houseRules: this.houseRules.text }
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
        this.trackStep('house-info')

        if (this.stepName === 'has-pets' && this.hasPets.isTrue) {
          this.$router.push({ params: { stepName: 'pet-description' } })
        } else if (this.stepName === 'has-pets' && !this.hasPets.isTrue) {
          this.$router.push({ params: { stepName: 'house-rules' } })
        } else if (this.stepName === 'pet-description') {
          this.$router.push({ params: { stepName: 'house-rules' } })
        } else if (this.stepName === 'house-rules') {
          this.$emit('finished')
        }

        this.showError = false
        window.scrollTo(0, 0)
      } else {
        this.showError = true
      }
    },
    prevStep () {
      if (this.stepName === 'has-pets') {
        this.$emit('backout')
      } else if (this.stepName === 'pet-description') {
        this.$router.replace({ params: { stepName: 'has-pets' } })
      } else if (this.stepName === 'house-rules' && this.hasPets.isTrue) {
        this.$router.replace({ params: { stepName: 'pets-description' } })
      } else if (this.stepName === 'house-rules' && !this.hasPets.isTrue) {
        this.$router.replace({ params: { stepName: 'has-pets' } })
      }
      this.showError = false
      window.scrollTo(0, 0)
    }
  }
}
</script>

<style scoped>

</style>
