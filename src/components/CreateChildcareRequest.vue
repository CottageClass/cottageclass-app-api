<template>
  <div>
    <Nav
      :button="nextButtonState"
      @next="nextStep"
      @prev="prevStep"
      :hidePrevious="stepIndex===0"
    />
    <ErrorMessage v-if="errorMessage && showError" :text="errorMessage" />
    <Question v-if="stepName==='description'"
      title="Describe your request"
      subtitle="What are you looking for? For what times? What kinds of needs does your child have? Parents near you will see your request and reply by text message. We strongly recommend meeting them for a playdate first!">
      <FormWithTextArea
        maxLength="120"
        placeholder="Describe your playdate here, e.g. 'Come over and play at our house!'"
        v-model="description.text" />
    </Question>
    <Question v-if="stepName==='success'"
      title="Describe your request"
      subtitle="What are you looking for? For what times? What kinds of needs does your child have? Parents near you will see your request and reply by text message. We strongly recommend meeting them for a playdate first!">
    share button
    </Question>
  </div>
</template>

<script>
import Nav from '@/components/FTE/Nav'
import Question from '@/components/base/Question.vue'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import { stepNavigation } from '@/mixins'
import { submitChildcareRequest } from '@/utils/api'

export default {
  name: 'CreateChildcareRequest',
  components: { Question, FormWithTextArea, Nav, ErrorMessage },
  props: ['stepName'],
  mixins: [stepNavigation],
  data () {
    return {
      showError: false,
      description: { text: '', err: null }
    }
  },
  computed: {
    errorMessage () {
      return this.description.err
    },
    nextButtonState () {
      if (this.stepName === 'success') {
        return 'done'
      } else if (this.errorMessage) {
        return 'inactive'
      } else {
        return 'next'
      }
    },
    stepSequence () {
      return ['description', 'success']
    }
  },
  methods: {
    nextStep () {
      if (this.nextButtonState === 'skip') {
        this.$emit('skip')
      } else if (this.errorMessage) {
        this.showError = true
      } else {
        // state is persisted after route update because component is reused
        this.showError = false
        if (this.stepName === 'description') {
          submitChildcareRequest(this.description.text)
          this.$router.push({
            params: { stepName: this.stepSequence[this.stepIndex + 1] }
          })
        } else {
          this.$router.push({ name: 'Search' })
        }
      }
    },
    prevStep () {
      if (this.stepIndex > 0) {
        this.$router.replace({ params: { stepName: this.stepSequence[this.stepIndex - 1] } })
      }
    }
  },
  watch: {
    'description.text': {
      handler () {
        if (this.description.text.length === 0) {
          this.description.err = 'Please enter a description for your request'
        } else {
          this.description.err = null
        }
      },
      immediate: true
    }
  },
  created () {
    this.$emit('input', { err: this.errorMessage, text: this.description })
  }
}
</script>
