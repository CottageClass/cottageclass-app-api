import { mount } from '@vue/test-utils'
import MultipleTimeSelector from '@/components/base/eventSpecification/MultipleTimeSelector'
import moment from 'moment'

describe('MultipleTimeSelector', () => {
  beforeAll(() => {
  })

  it('shows firstDisplay first', () => {
    const value = {
      availability: Array(7).fill(Array(24).fill(false))
    }
    const scheduleStartTime = moment('2019-05-21T11:30') // Tuesday 11:30 am local time
    const wrapper = mount(MultipleTimeSelector, {
      propsData: {
        value, scheduleStartTime
      }
    })
    const days = wrapper.findAll('.day-of-week')
    const items = wrapper.findAll('.time-label')

    expect(days).toHaveLength(8)
    expect(items).toHaveLength(7 * 16)
    expect(items.at(0).text()).toEqual('12pm')
  })
})
