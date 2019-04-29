<template>
  <!-- Proper indentation here would cause spaces to get inserted incorrectly between punctuation like periods, commas.-->
  <span>{{text}}</span>
</template>

<script>
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
    childAgesSorted: function () {
      return this.childAges.concat().sort((a, b) => a - b)
    },
    text () {
      const ages = this.childAgesSorted.filter(e => e >= 0)
      const n = ages.length
      if (this.verbose) {
        switch (n) {
          case 0:
            return 'Expecting'
          case 1:
            return this.prefix + '1 ' + this.singular + '–age ' + ages[0]
          default: // 2 or more
            return `${this.prefix}${n} ${this.plural}–ages ${ages.slice(0, n - 1).join(', ')} and ${ages[n - 1]}`
        }
      } else {
        if (n === 0) {
          return 'Expecting'
        } else {
          return n + ' ' + (ages.length > 1 ? this.plural : this.singular) + ' (' + ages.join(', ') + ')'
        }
      }
    }
  }
}
</script>
