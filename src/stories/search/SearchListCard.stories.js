import { storiesOf } from '@storybook/vue'
import SearchListCard from '@/components/search/SearchListCard.vue'
import Vue from 'vue'

import { withKnobs, text, array, number } from '@storybook/addon-knobs'

Vue.component('SearchListCard', SearchListCard)

storiesOf('SearchListCard', module)
  .addDecorator(withKnobs)
  .add('with only a user', () => ({
    components: { SearchListCard },
    computed: {},
    props: {
      user: {
        default: {
          facebookUid: text('facebookUid (clear to hide badge)', '563930223'),
          childAgesInMonths: array('child ages', [1, 34, 99], ','),
          firstName: text('first name', 'Lucas'),
          lastInitial: text('last initial', 'V'),
          jobPosition: text('job position', 'Doctor'),
          employer: text('employer', ''),
          profileBlurb: text('blurb', 'Let me tell you all about me!  I am a super fast runner and I can bake cookies'),
          fuzzyLatitude: number('lattitude', 43),
          fuzzyLongitude: number('longitude', -71)
        }
      },
      mapCenter: {
        default: {
          lat: number('map lattitude', 43.1),
          lng: number('map longitude', -71.1)
        }
      }
    },
    template: `<div style="max-width:524px"> <SearchListCard :user="user" :mapCenter="mapCenter"/> </div>`
  }))
