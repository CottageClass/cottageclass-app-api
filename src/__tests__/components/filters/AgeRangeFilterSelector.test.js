import { mount } from '@vue/test-utils'
import AgeRangeFilterSelector from '@/components/filters/AgeRangeFilterSelector.vue'

describe('FilterSelector', () => {
  let wrapper

  describe('mounting', () => {
    it('mounts with basic info', () => {
      wrapper = mount(AgeRangeFilterSelector, {
        propsData: {
          value: {
            err: null,
            data: {
              min: -1,
              max: -1
            }
          }
        }
      })
      const selects = wrapper.findAll('select')
      expect(selects).toHaveLength(2)
    })
  })
})
