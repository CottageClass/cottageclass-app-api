import { mount } from '@vue/test-utils'
import PageActionsFooter from '@/components/PageActionsFooter.vue'

describe('PageActionsFooter', () => {
  describe('one button', () => {
    it('triggers event on click', () => {
      const buttonData = {
        text: 'hello'
      }
      const wrapper = mount(PageActionsFooter, {
        propsData: {
          buttons: [buttonData]
        }
      })
      const primaryButton = wrapper.find('.button-primary')
      const secondaryButton = wrapper.find('.button-secondary')
      primaryButton.trigger('click')

      expect(secondaryButton.exists()).toBeFalsy()
      expect(primaryButton.text()).toBe('hello')
      expect(wrapper.emitted()['primary-click']).toBeTruthy()
    })
  })
  describe('two buttons', () => {
    it('triggers event on click', () => {
      const buttonData = [{
        text: 'hello'
      }, {
        text: 'goodbye'
      }]

      const wrapper = mount(PageActionsFooter, {
        propsData: {
          buttons: buttonData
        }
      })
      const secondary = wrapper.find('.button-secondary')
      secondary.trigger('click')

      expect(secondary.text()).toBe('goodbye')
      expect(wrapper.emitted()['secondary-click']).toBeTruthy()
    })
  })

  describe('inactive buttons', () => {
    it('triggers event on click', () => {
      const buttonData = [{
        text: 'hello',
        active: true
      }, {
        text: 'goodbye',
        active: false
      }]

      const wrapper = mount(PageActionsFooter, {
        propsData: {
          buttons: buttonData
        }
      })
      const secondary = wrapper.find('.button-secondary')
      const primary = wrapper.find('.button-primary')
      secondary.trigger('click')
      primary.trigger('click')

      expect(wrapper.emitted()['primary-click']).toBeTruthy()
      expect(wrapper.emitted()['secondary-click']).toBeFalsy()
    })
  })
})
