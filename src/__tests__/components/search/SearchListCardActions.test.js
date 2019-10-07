import { mount } from '@vue/test-utils'
import SearchListCardActions from '@/components/search/SearchListCardActions'

describe('SearchListCardActions', () => {
  describe('emits events', () => {
    let wrapper
    beforeEach(() => {
      const $store = {
        getters: {
          isAuthenticated: false
        },
        commit: jest.fn()
      }
      const event = { participated: false }
      const user = { starred: false }
      wrapper = mount(SearchListCardActions, {
        mocks: { $store },
        propsData: {
          showGoingButton: true,
          showCancelButton: true,
          showShareButton: true,
          showInterestedButton: true,
          event,
          user
        }
      })
    })
    it.each([
      [ '.going-button', 'going-click' ],
      [ '.interested-button', 'interested-click' ],
      [ '.share-button', 'share-click' ],
      [ '.cancel-button', 'cancel-click' ]
    ])('%s button emits %s event', (selector, event) => {
      const goingButton = wrapper.find(selector)
      goingButton.trigger('click')
      expect(wrapper.emitted(event)).toBeTruthy()
    })
  })
})
