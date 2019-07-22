import { mount } from '@vue/test-utils'
import SearchListCardActions from '@/components/search/SearchListCardActions'

describe('SearchListCardActions', () => {
  it('redirects going click when not authenticated', done => {
    const $route = { name: 'mock route name' }
    const $router = {
      push: jest.fn()
    }
    const $store = {
      getters: {
        isAuthenticated: false
      },
      commit: jest.fn()
    }
    const event = { participated: false }
    const wrapper = mount(SearchListCardActions, {
      mocks: { $store, $router, $route },
      propsData: {
        showGoingButton: true,
        event
      }
    })
    const goingButton = wrapper.find('.going-button')
    goingButton.trigger('click')
    wrapper.vm.$nextTick(() => {
      expect($router.push).toHaveBeenCalled()
      done()
    })
  })
})
