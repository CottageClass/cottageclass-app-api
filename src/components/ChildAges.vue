<template>
  <!-- Proper indentation here would cause spaces to get inserted incorrectly between punctuation like periods, commas.-->
  <span>{{text}}</span>
</template>

<script>
import { childAgeText } from '@/utils/utils'

export default {
  name: 'ChildAges',
  props: {
    childAges: {},
    singular: {},
    plural: {},
    verbose: {
      default: true
    },
    prefix: {
      default: ''
    }
  },
  computed: {
    text () {
      const { childAges, singular, plural, verbose, prefix } = this

      return childAgeText({ childAges, singular, plural, verbose, prefix })
    }
  }
}
</script>
