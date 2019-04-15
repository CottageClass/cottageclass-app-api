import { mount } from '@vue/test-utils'
import EventActivity from '@/components/base/eventSpecification/EventActivity.vue'
import _ from 'lodash'

const ACTIVITIES = [
  'Arts & Crafts',
  'Baby playgroup',
  'Books & Storytime',
  'Drawing & Coloring',
  'Games & Puzzles',
  'Kids\' Movie Night',
  'Playing outside (weather permitting)',
  'Playground Meetup',
  'Waldorf Nature Walk'
]
describe('EventActivity', () => {
  let wrapper
  beforeAll(async () => {
    wrapper = mount(EventActivity, {
      propsData: {
        value: {}
      }
    })
  })

  it('shows the right activities', () => {
    const names = _.map(wrapper.findAll('input').wrappers, w => w.attributes().name)
    expect(names).toEqual(ACTIVITIES)
  })
})
