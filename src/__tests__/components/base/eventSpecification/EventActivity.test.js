import { mount } from '@vue/test-utils'
import EventActivity from '@/components/base/eventSpecification/EventActivity.vue'

const ages = {
  'Arts & Crafts': [2, 11],
  'Baby playgroup': [0, 3],
  'Books & Storytime': [0, 9],
  'Drawing & Coloring': [0, 9],
  'Games & Puzzles': [3, 11],
  'Kids\' Movie Night': [3, 11],
  'Playing outside (weather permitting)': [0, 11],
  'Playground Meetup': [0, 11],
  'Waldorf Nature Walk': [0, 11]
}

const ACTIVITIES = [
  'Arts & Crafts (ages 2-11)',
  'Baby playgroup (ages 0-3)',
  'Books & Storytime (ages 0-9)',
  'Drawing & Coloring (ages 0-9)',
  'Games & Puzzles (ages 3-11)',
  'Kids\' Movie Night (ages 3-11)',
  'Playing outside (weather permitting) (ages 0-11)',
  'Playground Meetup (ages 0-11)',
  'Waldorf Nature Walk (ages 0-11)'
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
    const names = wrapper.findAll('input').wrappers.map((w) => {
      const name = w.attributes().name
      return name + ' (ages ' + ages[name][0] + '-' + ages[name][1] + ')'
    })
    expect(names).toEqual(ACTIVITIES)
  })
})
