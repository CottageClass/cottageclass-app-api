import { mount } from '@vue/test-utils'
import FilterSelector from '@/components/filters/FilterSelector.vue'

describe('FilterSelector', () => {
  let wrapper

  describe('mounting', () => {
    it('displays slot info on button', () => {
      const selector = {
        name: 'TestFilterSelector',
        template: '<p class="selector-slot">hi</p>'
      }
      const button = {
        name: 'TestFilterButton',
        template: '<p class="button-slot">hi</p>'
      }
      wrapper = mount(FilterSelector, {
        propsData: {
          title: 'test title'
        },
        slots: {
          buttonContents: button,
          selectorContents: selector
        }
      })
      const buttonSlot = wrapper.find('.button-slot')
      const selectorSlot = wrapper.find('.selector-slot')

      expect(selectorSlot.exists()).toBeFalsy()
      expect(buttonSlot.text()).toBe('hi')
    })
  })
})
