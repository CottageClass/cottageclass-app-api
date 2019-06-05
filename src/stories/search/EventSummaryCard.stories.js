import { storiesOf } from '@storybook/vue'
import EventSummaryCard from '@/components/search/EventSummaryCard.vue'
import Vue from 'vue'

import { withKnobs, text, array, number } from '@storybook/addon-knobs'

Vue.component('EventSummaryCard', EventSummaryCard)

storiesOf('EventSummaryCard', module)
  .addDecorator(withKnobs)
  .add('as a component', () => ({
    components: { EventSummaryCard },
    computed: {},
    props: {
      user: {
        default: {
          facebookUid: text('facebookUid (clear to hide badge)', '563930223'),
          childAgesInMonths: array('child ages', [1, 34, 99], ','),
          firstName: text('first name', 'Lucas'),
          jobPosition: text('job position', 'Doctor'),
          employer: text('employer', ''),
          location: {
            lat: number('lattitude', 42.2798695),
            lng: number('longitude', -71.7898409)
          }
        }
      }
    },
    template: `<div style="max-width:524px"> <EventSummaryCard :user="user"/> </div>`
  }))
