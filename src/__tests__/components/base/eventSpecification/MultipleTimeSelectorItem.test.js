import { mount } from '@vue/test-utils'
import MultipleTimeSelectorItem from '@/components/base/eventSpecification/MultipleTimeSelectorItem'

describe('MultipleTimeSelectorItem', () => {
  describe('mounting', () => {
    let wrapper
    beforeEach(() => {
      wrapper = mount(MultipleTimeSelectorItem, {
        propsData: {
          startHour: 16,
          selected: false
        }
      })
    })

    it('works as a selector', () => {
      const label = wrapper.find('.time-label')
      wrapper.trigger('click')

      expect(label.text()).toEqual('4pm')
      expect(wrapper.emitted().input[0]).toEqual([ true ])
    })
  })

  describe.each([
    [0, '12am'],
    [11, '11am'],
    [12, '12pm'],
    [23, '11pm']]
  )('hour %i', (startHour, expected) => {
    const wrapper = mount(MultipleTimeSelectorItem, {
      propsData: {
        startHour: startHour,
        selected: false
      }
    })
    it(`return ${expected}`, () => {
      const label = wrapper.find('.time-label')
      expect(label.text()).toEqual(expected)
    })
  })
})
