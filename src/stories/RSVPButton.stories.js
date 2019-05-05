import { storiesOf } from '@storybook/vue'
import RsvpButton from '../components/RsvpButton.vue'
import Vue from 'vue'

Vue.component('RsvpButton', RsvpButton)

storiesOf('RsvpButton', module)
  .add('as a component', () => ({
    components: { RsvpButton },
    template: '<RsvpButton />'
  }))
