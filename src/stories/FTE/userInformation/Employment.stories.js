import { storiesOf } from '@storybook/vue'
import Employment from '@/components/FTE/userInformation/Employment.vue'
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import Vue from 'vue'

Vue.component('Employment', Employment)

storiesOf('Employment', module)
  .add('with no existing info', () => ({
    components: { Employment },
    template: '<Employment jobPosition="" employer=""/>'
  }))
  .add('with some data in the onboarding style', () => ({
    components: { Employment, StyleWrapper },
    template: '<StyleWrapper styleIs="onboarding"> <Employment jobPosition="Master" employer="universe"/></StyleWrapper>'
  }))
  .add('with some data in the editing style', () => ({
    components: { Employment, StyleWrapper },
    template: '<StyleWrapper styleIs="editing"> <Employment jobPosition="Master" employer="universe"/></StyleWrapper>'
  }))
