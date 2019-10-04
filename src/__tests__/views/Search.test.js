import { shallowMount, createLocalVue } from '@vue/test-utils'
import Search from '@/views/Search.vue'
import Vuex from 'vuex'

jest.mock('@/utils/api')
const localVue = createLocalVue()

localVue.use(Vuex)

describe('Search', () => {
  let wrapper
  describe('no current user', () => {
    beforeAll(async () => {
      const actions = {
        fetchUpcomingEventsWithinDistance: jest.fn()
      }
      const $store = new Vuex.Store({
        actions,
        getters: {
          pendingWaves: () => [],
          currentUser () { return null },
          showFetchMoreButton () { return false },
          isAuthenticated () { return false },
          items () { return [] },
          lastPage () { return 0 },
          mapArea () {
            return {
              center: {
                lat: 41.96,
                lng: -73.65
              }
            }
          }
        }
      })
      wrapper = shallowMount(Search, {
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
