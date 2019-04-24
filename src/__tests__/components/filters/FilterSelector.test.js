import { mount } from '@vue/test-utils'
import FilterSelector from '@/components/filters/FilterSelector.vue'
import Vue from 'vue'

describe('FilterSelector', () => {
  let wrapper

  describe('mounting', () => {
    it('displays slot info on button', () => {
      const selector = {
        name: 'TestFilterSelector',
        template: '<p class="button-slot">hi</p>'
      }
      const button = {
        name: 'TestFilterButton',
        template: '<p class="selector-slot">hi</p>'
      }
      wrapper = mount(FilterSelector, {
        propsData: {
          filterName: 'coffee type'
        },
        slots: {
          buttonContents: button,
          selectorContents: selector
        }
      })
      const selectorSlot = wrapper.find('.button-slot')
      const buttonSlot = wrapper.find('.selector-slot')

      expect(selectorSlot.exists()).toBeTruthy()
      expect(buttonSlot.text()).toBe('hi')
    })
  })
})
