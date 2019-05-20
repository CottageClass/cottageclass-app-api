import { mount } from '@vue/test-utils'
import MultipleTimeSelector from '@/components/base/eventSpecification/MultipleTimeSelector'

describe('MultipleTimeSelector', () => {
  beforeAll(() => {
  })

  it('shows firstDisplay first', () => {
    const selectedTimes = Array(24 * 7).fill(false)
    const firstDisplay = 60 // Tuesday 12pm local time
    const wrapper = mount(MultipleTimeSelector, {
      propsData: {
        selectedTimes, firstDisplay
      }
    })
    const items = wrapper.findAll('.time-selector-item').wrappers

    expect(items).toHaveLength(7 * 16)
    expect(items[0]).props('startHour').toEqual(firstDisplay)
  })
})
