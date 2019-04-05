<template>
  <Question
    :title="question"
    :subtitle="description">
    <RadioButtons
      v-model="yesOrNo"
      :choices="[yesText, noText]" />
    <slot></slot>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import RadioButtons from '@/components/base/RadioButtons.vue'

export default {
  name: 'YesOrNo',
  components: { Question, RadioButtons },
  props: {
    value: Object,
    question: String,
    description: String,
    yesText: {
      type: String,
      default: 'yes'
    },
    noText: {
      type: String,
      default: 'no'
    }
  },
  data () {
    return {
      yesOrNo: this.value.isTrue ? 'yes' : (this.value.isTrue === false ? 'no' : null),
      errorMesg: `Please answer ${this.yesText} or ${this.noText}.`
    }
  },
  mounted: function () {
    this.emitData()
  },
  methods: {
    emitData: function () {
      this.$emit('input', Object.assign(this.value, {
        isTrue: this.trueOrFalse,
        err: this.err
      }))
    }
  },
  computed: {
    err: function () {
      if (this.trueOrFalse === null) {
        return this.errorMesg
      } else {
        return false
      }
    },
    trueOrFalse: function () {
      switch (this.yesOrNo) {
        case this.yesText:
          return true
        case this.noText:
          return false
        default:
          return null
      }
    }
  },
  watch: {
    yesOrNo: function () {
      this.emitData()
    }
  }
}
</script>
