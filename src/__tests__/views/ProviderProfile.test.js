import { shallowMount } from '@vue/test-utils'
import ProviderProfile from '@/views/ProviderProfile.vue'

describe('ProviderProfile', () => {
  let wrapper
  describe('no current user', () => {
    beforeAll(async () => {
      const $route = {
        path: '/user/1281',
        params: { id: 1281 }
      }
      const $store = {
        getters: { currentUser: null }
      }
      wrapper = shallowMount(ProviderProfile, {
        mocks: { $route, $store },
        stubs: [ 'GmapMap', 'GmapMarker' ] // because the are globally registered.  this silences the warning
      })
    })

    it('mounts with the correct information', async () => {
      const name = wrapper.find('.name-heading')
      expect(name.text()).toBe('Ari')

      const memberSince = wrapper.find('.member-since')
      expect(memberSince.text()).toBe('Member since March, 2019')

      const employment = wrapper.find('.occupation')
      expect(employment.text()).toBe('coder, KidsClub!!!!')

      const edit = wrapper.find('.edit-button')
      expect(edit.exists()).toBeFalsy()
    })
  })

  describe('with current user', () => {
    beforeAll(async () => {
      const $route = {
        path: '/user/1281',
        params: { id: 1281 }
      }
      const $store = {
        getters: { currentUser: { id: 1281 } }
      }
      wrapper = shallowMount(ProviderProfile, {
        mocks: { $route, $store },
        stubs: [ 'GmapMap', 'GmapMarker' ] // because the are globally registered.  this silences the warning
      })
    })

    it('mounts with the correct information', async () => {
      const name = wrapper.find('.name-heading')
      expect(name.text()).toBe('Ari')

      const memberSince = wrapper.find('.member-since')
      expect(memberSince.text()).toBe('Member since March, 2019')

      const employment = wrapper.find('.occupation')
      expect(employment.text('coder, KidsClub!!!!'))

      const edit = wrapper.find('.edit-button')
      expect(edit.exists()).toBeTruthy()
    })

    it('shows the correct availability', () => {
      const times = wrapper.findAll('.availability-tag').wrappers
      expect(times).toHaveLength(2)
      expect(times[0].text()).toBe('3pm-7pm')
      expect(times[1].text()).toBe('7pm- ?')
    })

    it('shows the correct activities', () => {
      const activities = wrapper.findAll('.activity-tag').wrappers
      expect(activities).toHaveLength(2)
      expect(activities[0].text()).toBe('travel')
      expect(activities[1].text()).toBe('movies')
    })

    it('shows the correct bio blurb', () => {
      const blurb = wrapper.find('.blurb')
      expect(blurb.text()).toBe('I was born outside of boston and now i live in nyc')
    })

    it('shows the correct languages', () => {
      const languages = wrapper.find('.languages')
      expect(languages.text()).toBe('Speaks English, Italian and Spanish')
    })
  })

  describe('single language', () => {
    beforeAll(async () => {
      const $route = {
        path: '/user',
        params: { id: 1230 }
      }
      const $store = {
        getters: { currentUser: null }
      }
      wrapper = shallowMount(ProviderProfile, {
        mocks: { $route, $store },
        stubs: [ 'GmapMap', 'GmapMarker' ] // because the are globally registered.  this silences the warning
      })
    })

    it('shows the correct language', () => {
      const languages = wrapper.find('.languages')
      expect(languages.text()).toBe('Speaks Spanish')
    })
  })
})
