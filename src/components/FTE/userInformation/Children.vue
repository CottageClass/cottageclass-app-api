<template>
  <Question
    title="Child Information"
    subtitle="Only the hosts of playdates you attend will see names, and birthdays are private. (We only collect them so we can show correct ages for each family's children, to help you find friends!)">
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
      errorMesg: 'Please enter a first name (or nickname) and birthdate for each child.',
    }
  },
  computed: {
    childrenValidates: function () {
      // child has name and birthday
      let childValidates = function (child) {
        return (
          child.birthday &&
          child.firstName &&
          child.birthday.length > 0 &&
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
    listOfYears: function(){
           const year = new Date().getFullYear()
           return Array.from({length: 20}, (value, index) => year - index)
    },
    fieldGroups: function(){
      return [
        {
          name: 'firstName',
          label: 'First Name (or nickname)',
          placeholder: 'First Name',
          type: 'text'
        },
        {
          name: "birthMonth",
          label: 'Select Birth Month',
          placeholder: 'MM',
          type: 'select',
          selectData: [
            { text: 'January', value: '1' },
            { text: 'February', value: '2' },
            { text: 'March', value: '3' },
            { text: 'April', value: '4' },
            { text: 'May', value: '5' },
            { text: 'June', value: '6' },
            { text: 'July', value: '7' },
            { text: 'August', value: '8' },
            { text: 'September', value: '9' },
            { text: 'October', value: '10' },
            { text: 'November', value: '11' },
            { text: 'December', value: '12' }
          ]
        },
        {
          name: 'birthYear',
          label: 'Select Birth Year',
          placeholder: 'YYYY',
          type: 'select',
          selectData: this.listOfYears.map(x => {
              return {text: x, value: x}
            }
          )
        },
        {
          name: 'schoolName',
          label: 'School Name (optional)',
          placeholder: 'Name of School',
          type: 'text'
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
