import ContactForm from '@/views/ContactForm'
import { mount } from '@vue/test-utils'

import moment from 'moment'

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
        mocks: { $store, $router, $route },
        propsData: {
          eventId: 2186
        }
      })

      wrapper.vm.$nextTick(() => {
        expect($router.push).toHaveBeenCalled()
        done()
      })
    })
  })

  describe('authenticated', () => {
    const $router = {
      push: jest.fn()
    }
    it('does not redirect', () => {
      const $store = {
        getters: {
          isAuthenticated: true
        }
      }
      mount(ContactForm, {
        mocks: { $store, $router },
        propsData: {
          eventId: 2186
        }
      })

      expect($router.push).not.toHaveBeenCalled()
    })
    it('has the right message with some kids', () => {
      const $store = {
        getters: {
          isAuthenticated: true,
          currentUser: {
            firstName: 'Joe',
            childAgesInMonths: [-1, 2, 66]
          }
        }
      }
      const wrapper = mount(ContactForm, {
        mocks: { $store, $router },
        propsData: {
          eventId: 2186
        }
      })
      wrapper.vm.event = {
        startsAt: moment('2019-03-23T18:00:00-04:00')
      }
      expect(wrapper.vm.fullMessageText).toMatchSnapshot()
    })
    it('has the right message with no kids', () => {
      const $store = {
        getters: {
          isAuthenticated: true,
          currentUser: {
            firstName: 'Joe',
            childAgesInMonths: [-1]
          }
        }
      }
      const wrapper = mount(ContactForm, {
        mocks: { $store, $router },
        propsData: {
          eventId: 2186
        }
      })
      wrapper.vm.event = {
        startsAt: moment('2019-03-23T18:00:00-04:00')
      }
      expect(wrapper.vm.fullMessageText).toMatchSnapshot()
    })
  })
})
