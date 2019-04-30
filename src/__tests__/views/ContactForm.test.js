import ContactForm from '@/views/ContactForm'
import { mount } from '@vue/test-utils'

describe('ContactForm', () => {
  describe('unauthenticated', () => {
    it('redirects', (done) => {
      const $store = {
        getters: {
          isAuthenticated: false
        },
        commit: jest.fn()
      }
      const $router = {
        push: jest.fn()
      }
      const $route = {
        name: 'ContactForm'
      }
      const wrapper = mount(ContactForm, {
        mocks: { $store, $router, $route }
      })

      wrapper.vm.$nextTick(() => {
        expect($router.push).toHaveBeenCalled()
        done()
      })
    })
  })
  describe('authenticated', () => {
    it('does not redirect', () => {
      const $store = {
        getters: {
          isAuthenticated: true
        }
      }
      const $router = {
        push: jest.fn()
      }
      mount(ContactForm, {
        mocks: { $store, $router }
      })

      expect($router.push).not.toHaveBeenCalled()
    })
  })
})
