import { mount } from '@vue/test-utils'
import FacebookButton from '@/components/base/FacebookButton.vue'

describe('FacebookButton', () => {
  describe('basic mounting', () => {
    it('responds to a click', () => {
      const mockAuth = jest.fn()
      const providerAuthentication = {
        methods: {
          authenticateFacebook: mockAuth
        }
      }
      const wrapper = mount(FacebookButton, {
        mixins: [providerAuthentication]
      })
      const mainButton = wrapper.find('.fb-button')
      mainButton.trigger('click')
      expect(mockAuth).toHaveBeenCalled()
    })
  })
})
