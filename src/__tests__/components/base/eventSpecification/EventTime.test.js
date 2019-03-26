import { mount } from '@vue/test-utils'
import EventTime from '@/components/base/eventSpecification/EventTime.vue'
import _ from 'lodash'

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
  beforeAll(async () => {
    wrapper = mount(EventTime)
  })

  it('shows the right times', () => {
    const names = _.map(wrapper.findAll('input').wrappers, w => w.attributes().name)
    expect(names).toEqual(TIMES)
  })
})
