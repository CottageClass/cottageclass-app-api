import { shallowMount } from '@vue/test-utils'
import MainNav from '@/components/MainNav.vue'

describe('MainNav', () => {
  let wrapper

  describe('unauthenticated', () => {
    beforeAll(async () => {
      const $store = {
        getters: {
          currentUser: null,
          isAuthenticated: false
        }
      }
      wrapper = shallowMount(MainNav, {
        stubs: ['router-link'],
        mocks: { $store }
      })
    })

    it('has correct  list items', done => {
      const dropdownButton = wrapper.find('.nav-menu-button')
      dropdownButton.trigger('click')
      wrapper.vm.$nextTick(() => {
        const list = wrapper.find('.nav-links-expanded ul')
        const itemLabels = list.findAll('li div').wrappers.map(w => w.text())
        expect(itemLabels).toMatchSnapshot()
        done()
      })
    })
  })
  describe('authenticated', () => {
    beforeAll(async () => {
      const $store = {
        getters: {
          currentUser: null,
          isAuthenticated: true
        }
      }
      wrapper = shallowMount(MainNav, {
        stubs: ['router-link'],
        mocks: { $store }
      })
    })

    it('has correct  list items', done => {
      const dropdownButton = wrapper.find('.nav-menu-button')
      dropdownButton.trigger('click')
      wrapper.vm.$nextTick(() => {
        const list = wrapper.find('.nav-links-expanded ul')
        const itemLabels = list.findAll('li div').wrappers.map(w => w.text())
        expect(itemLabels).toMatchSnapshot()
        done()
      })
    })
  })
})
