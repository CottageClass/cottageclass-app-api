import { shallowMount, createLocalVue } from '@vue/test-utils'
import Events from '@/views/Events.vue'
import Vuex from 'vuex'

const localVue = createLocalVue()

localVue.use(Vuex)

describe('Events', () => {
  let wrapper
  describe('no current user', () => {
    beforeAll(async () => {
      const actions = {
        fetchUpcomingEventsWithinDistance: jest.fn()
      }
      const $store = new Vuex.Store({
        actions,
        getters: {
          currentUser () { return null },
          isAuthenticated () { return false },
          mapArea () {}
        }
      })
      wrapper = shallowMount(Events, {
        mocks: { $store },
        stubs: [ 'GmapMap', 'GmapMarker' ] // because the are globally registered.  this silences the warning
      })
    })

    it('mounts with a map and a list', async () => {
      const map = wrapper.find('.map')
      expect(map.exists()).toBeTruthy()
      const list = wrapper.find('.list')
      expect(list.exists()).toBeTruthy()
    })
  })
})
