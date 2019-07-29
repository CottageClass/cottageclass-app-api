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
      const $route = {}
      wrapper = shallowMount(MainNav, {
        stubs: ['router-link'],
        mocks: { $store, $route }
      })
    })

    it('responds', () => {
      const dropdownButton = wrapper.find('.navigation__profile-menu-button')
      expect(dropdownButton.exists()).toBeFalsy()
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
      const $route = {}
      wrapper = shallowMount(MainNav, {
        stubs: ['router-link'],
        mocks: { $store, $route }
      })
    })

    it('has no menu', () => {
      const dropdownButton = wrapper.find('.navigation__profile-menu-button')
      dropdownButton.trigger('click')
      expect(wrapper.vm.showMenu).toBeTruthy()
    })
  })
})
