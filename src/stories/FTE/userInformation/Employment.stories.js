import { storiesOf } from '@storybook/vue'
import Employment from '@/components/FTE/userInformation/Employment.vue'
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import Vue from 'vue'

Vue.component('Employment', Employment)

storiesOf('Employment', module)
  .add('with no existing info', () => ({
    components: { Employment },
    data () {
      return {
        val: { jobPosition: '', employer: '' }
      }
    },
    template: '<Employment v-model="val"/>'
  }))
  .add('with some data in the onboarding style', () => ({
    components: { Employment, StyleWrapper },
    data () {
      return {
        val: { jobPosition: 'Master', employer: 'Univers' }
      }
    },
    template: '<StyleWrapper styleIs="onboarding"> <Employment v-model="val"/></StyleWrapper>'
  }))
  .add('with some data in the editing style', () => ({
    components: { Employment, StyleWrapper },
    data () {
      return {
        val: { jobPosition: 'Master', employer: 'Univers' }
      }
    },
    template: '<StyleWrapper styleIs="editing"> <Employment v-model="val"/></StyleWrapper>'
  }))
