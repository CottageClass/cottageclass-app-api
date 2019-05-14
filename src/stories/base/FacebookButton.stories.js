
import { storiesOf } from '@storybook/vue'
import FacebookButton from '@/components/base/FacebookButton.vue'
import Vue from 'vue'

Vue.component('FacebookButton', FacebookButton)

storiesOf('FacebookButton', module)
  .add('with no existing info', () => ({
    components: { FacebookButton },
    data () {
      return {
      }
    },
    template: '<FacebookButton />'
  }))
