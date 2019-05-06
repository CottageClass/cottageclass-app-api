<template>
  <span>{{text}}</span>
</template>

<script>
import { childAgeText } from '@/utils/utils'

export default {
  name: 'ChildAges',
  props: {
    childAgesInMonths: {},
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
      const { childAgesInMonths, singular, plural, verbose, prefix } = this

      return childAgeText({ childAgesInMonths, singular, plural, verbose, prefix })
    }
  }
}
</script>
