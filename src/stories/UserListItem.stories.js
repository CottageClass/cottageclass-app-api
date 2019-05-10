import { storiesOf } from '@storybook/vue'
import UserListItem from '../components/UserListItem.vue'
import Vue from 'vue'
import { mapGetters } from 'vuex'

import { withKnobs, text, array, number } from '@storybook/addon-knobs'
import store from '@/store'

store.commit('setMapArea', {
  center: {
    lat: '42.279',
    lng: '-71.789'
  },
  maxDistance: 5
})

Vue.component('UserListItem', UserListItem)

storiesOf('UserListItem', module)
  .addDecorator(withKnobs)
  .add('as a component', () => ({
    components: { UserListItem },
    computed: mapGetters([ 'mapArea' ]),
    store,
    props: {
      user: {
        default: {
          facebooUid: text('facebookUid', 'Sample Title'),
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
    template: '<UserListItem :user="user"/>'
  }))
