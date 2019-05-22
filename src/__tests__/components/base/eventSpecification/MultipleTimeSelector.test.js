import { mount } from '@vue/test-utils'
import MultipleTimeSelector from '@/components/base/eventSpecification/MultipleTimeSelector'

describe('MultipleTimeSelector', () => {
  beforeAll(() => {
  })

  it('shows firstDisplay first', () => {
    const value = {
      availability: Array(7).fill(Array(24).fill(false))
    }
    const firstDisplay = 60 // Tuesday 12pm local time
    const wrapper = mount(MultipleTimeSelector, {
      propsData: {
        value, firstDisplay
      }
    })
    const days = wrapper.findAll('.day-of-week')
    const items = wrapper.findAll('.time-label')

    expect(days).toHaveLength(8)
    expect(items).toHaveLength(7 * 16)
    expect(items.at(0).text()).toEqual('12pm-1pm')
  })
})
