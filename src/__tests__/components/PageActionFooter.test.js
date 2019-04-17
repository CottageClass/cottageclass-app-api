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
  describe('slot buttons', () => {
    it('accepts a single button in a slot', () => {
      const slotComponent = {
        name: 'my-component',
        template: '<div class="my-component" />'
      }
      const buttonData = []
      const wrapper = mount(PageActionsFooter, {
        propsData: {
          buttons: buttonData
        },
        slots: {
          first: slotComponent
        }
      })
      const component = wrapper.find('.my-component')
      expect(component.exists()).toBeTruthy()
    })
    it('accepts an object first and a slot second', () => {
      const slotComponent = {
        name: 'my-component',
        template: '<div class="my-component" />'
      }
      const buttonData = [{
        text: 'hello',
        active: true
      }]
      const wrapper = mount(PageActionsFooter, {
        propsData: {
          buttons: buttonData
        },
        slots: {
          second: slotComponent
        }
      })
      const primary = wrapper.find('.button-primary')
      const secondary = wrapper.find('.button-secondary')
      const component = wrapper.find('.my-component')
      expect(component.exists()).toBeTruthy()
      expect(primary.exists()).toBeTruthy()
      expect(secondary.exists()).toBeFalsy()
    })

    it('accepts a slot first and an object second', () => {
      const slotComponent = {
        name: 'my-component',
        template: '<div class="my-component" />'
      }
      const buttonData = [{}, {
        text: 'hello',
        active: true
      }]
      const wrapper = mount(PageActionsFooter, {
        propsData: {
          buttons: buttonData
        },
        slots: {
          first: slotComponent
        }
      })
      const primary = wrapper.find('.button-primary')
      const secondary = wrapper.find('.button-secondary')
      const component = wrapper.find('.my-component')
      expect(component.exists()).toBeTruthy()
      expect(primary.exists()).toBeFalsy()
      expect(secondary.exists()).toBeTruthy()
    })
  })
})
