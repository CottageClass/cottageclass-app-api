import { mount } from '@vue/test-utils'
import EventTime from '@/components/base/eventSpecification/EventTime.vue'

const TIMES = [
  '9:00am - 12:00pm',
  '11:00am - 2:00pm',
  '2:00pm - 5:00pm',
  '3:00pm - 6:00pm',
  '4:00pm - 7:00pm',
  '5:00pm - 8:00pm',
  '5:30pm - 8:30pm',
  '6:00pm - 9:00pm',
  '6:30pm - 9:30pm',
  '7:00pm - 10:00pm'
]
describe('EventTime', () => {
  let wrapper
  const $route = {
    name: ''
  }
  beforeAll(async () => {
    wrapper = mount(EventTime, {
      mocks: { $route },
      propsData: {
        value: { err: null }
      }
    })
  })

  it('shows the right times', () => {
    const names = wrapper.findAll('input').wrappers.map(w => w.attributes().name)
    expect(names).toEqual(TIMES)
  })
})
