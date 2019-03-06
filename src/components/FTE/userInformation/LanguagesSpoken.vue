<template>
  <Question
    title="What languages do you speak?"
    subtitle="Many of our members are multilingual, so listing the languages you speak is a great way to connect with other families.">
    <a v-if="choicesAreHidden" @click="showChoices">Show choices</a>
    <MultipleChoice 
      v-if="!choicesAreHidden"
      v-model="languageCodesChosen"
      type="checkbox"
      :labelsAndOrder="labelsAndOrder"
      />
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import MultipleChoice from '@/components/base/MultipleChoice.vue'
var languages = require('language-list')()
export default {
  name: 'LanguagesSpoken',
  components: { Question, MultipleChoice },
  props: ['value'],
  data () {
    return {
      languages: languages.getData(),
      languageCodesChosen: this.value,
      choicesAreHidden: true
    }
  },
  methods: {
    showChoices: function () {
      this.choicesAreHidden = false
    }
  },
  computed: {
    labelsAndOrder: function () {
      return this.languagesSortedByName.map(language => [language.code, language.language])
    },
    languagesSortedByName: function () {
      return this.languages.sort((a, b) => a.language.localeCompare(b.language))
    }
  },
  watch: {
    languageCodesChosen: function () {
      this.$emit('input', this.languageCodesChosen)
    }
  }
}
</script>
