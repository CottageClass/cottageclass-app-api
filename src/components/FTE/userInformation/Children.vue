<template>
  <Question
    title="Child Information"
    subtitle="To match parents with kids of similar ages, we need to know the year and month each child was born. Ages are visible on the site, but names are private. If you're expecting (yay!) you can enter a due date.">
    <ManyFormFieldGroups
      :fieldGroups="fieldGroups"
      headingWord="Child"
      v-model="children"
      addAndRemove="true"
    />
  </Question>
</template>

<script>
import ManyFormFieldGroups from '@/components/base/ManyFormFieldGroups.vue'
import Question from '@/components/base/Question.vue'

export default {
  name: 'Children',
  props: ['value'],
  components: { Question, ManyFormFieldGroups },
  data () {
    return {
      children: this.value.list || [],
      errorMesg: 'Please enter a first name (or nickname) and birthdate for each child.'
    }
  },
  computed: {
    childrenValidates: function () {
      // child has name and birthday
      let childValidates = function (child) {
        return (
          child.birthMonth &&
          child.birthYear &&
          child.firstName &&
          child.firstName.length > 0
        )
      }
      if (this.children.length > 0 &&
        // validate that each child has name, birthday
        (this.children.reduce((soFar, child) => soFar && childValidates(child), true))) {
        return true
      } else {
        return false
      }
    },
    err: function () {
      if (this.childrenValidates) {
        return false
      } else {
        return this.errorMesg
      }
    },
    listOfYears: function () {
      const year = new Date().getFullYear()
      return Array.from({ length: 20 }, (value, index) => year - index)
    },
    fieldGroups: function () {
      return [
        {
          name: 'firstName',
          label: 'First Name (or nickname)',
          placeholder: 'First Name',
          type: 'text'
        },
        {
          name: 'birthYear',
          label: 'Birth Year',
          placeholder: 'Select',
          type: 'select',
          selectData: this.listOfYears.map(x => {
            return { text: x, value: x }
          }
          )
        },
        {
          name: 'birthMonth',
          label: 'Birth Month',
          placeholder: 'Select',
          type: 'select',
          selectData: [
            { text: 'January', value: '01' },
            { text: 'February', value: '02' },
            { text: 'March', value: '03' },
            { text: 'April', value: '04' },
            { text: 'May', value: '05' },
            { text: 'June', value: '06' },
            { text: 'July', value: '07' },
            { text: 'August', value: '08' },
            { text: 'September', value: '09' },
            { text: 'October', value: '10' },
            { text: 'November', value: '11' },
            { text: 'December', value: '12' }
          ]
        }
      ]
    }
  },
  mounted: function () {
    this.$emit('input', {
      list: this.children,
      err: this.err
    })
  },

  watch: {
    children: {
      handler: function () {
        this.$emit('input', {
          list: this.children,
          err: this.err
        })
      },
      deep: true
    }
  }
}
</script>
