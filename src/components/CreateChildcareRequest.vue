<template>
  <div>
    <NavUpdated
      :button="nextButtonState"
      @next="nextStep"
      @prev="prevStep"
      :hidePrevious="stepIndex===0"
    />
    <ErrorMessage v-if="errorMessage && showError" :text="errorMessage" />
    <QuestionNewStyle v-if="stepName==='description'"
              title="Describe your childcare request"
              subtitle="Parents near you will see your request and reply by text message. What are you looking for? For what times? What kinds of needs does your child have? (Note: if you do swap childcare with a parent, we strongly recommend meeting them for a playdate first.)">
      <FormWithTextArea
        placeholder="e.g. 'Can anyone recommend a great sitter?' or 'Seeking a childcare swap to cover Tuesday mornings in September.'"
        v-model="description.text" />
    </QuestionNewStyle>
  </div>
</template>

<script>
import NavUpdated from '@/components/FTE/NavUpdated.vue'
import QuestionNewStyle from '@/components/base/QuestionNewStyle.vue'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import { stepNavigation, alerts } from '@/mixins'
import { submitChildcareRequest } from '@/utils/api'

export default {
  name: 'CreateChildcareRequest',
  components: { QuestionNewStyle, FormWithTextArea, NavUpdated, ErrorMessage },
  props: ['stepName'],
  mixins: [stepNavigation, alerts],
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
      if (this.errorMessage) {
        return 'inactive'
      } else {
        return 'done'
      }
    },
    stepSequence () {
      return ['description']
    }
  },
  methods: {
    async nextStep () {
      if (this.nextButtonState === 'skip') {
        this.$emit('skip')
      } else if (this.errorMessage) {
        this.showError = true
      } else {
        this.showError = false
        try {
          await submitChildcareRequest(this.description.text)
          this.showAlertOnNextRoute('Your childcare request has been posted', 'success')
        } catch (e) {
          this.showAlertOnNextRoute('There was a problem submitting your request, please try again later', 'failure')
        } finally {
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
