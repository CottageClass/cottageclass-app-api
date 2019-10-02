import { mount } from '@vue/test-utils'
import MeetButton from '@/components/base/MeetButton.vue'

describe('MeetButton', () => {
  let wrapper

  describe('locality provided', () => {
    const targetUser = {
      id: '1230',
      firstName: 'Chuck',
      lastInitial: 'D',
      childAgesInMonths: [1, 15, 99],
      location: {
        lat: 41.969880,
        lng: -73.651964 },
      employer: 'Lockheed',
      jobPosition: 'engineer'
    }
    beforeAll(async () => {
      const $route = {
        name: 'Search'
      }
      const $router = { push: jest.fn() }
      const $store = {
        commit: jest.fn(),
        getters: {
          isAuthenticated: true,
          waveHasBeenSent: () => false,
          currentUser: {
            id: '987654321',
            firstName: 'Natasha',
            childAgesInMonths: [9, 100, 54],
            locality: 'Nashville',
            location: {
              lat: 41.9,
              lng: -73.6 }
          },
          distanceFromCurrentUser () {
            return 4.2
          }
        }
      }
      wrapper = mount(MeetButton, {
        mocks: { $router, $store, $route },
        stubs: ['router-link'],
        propsData: {
          targetUser,
          defaultText: 'Invite',
          showDescriptionModal: false,
          allowUndo: true
        }
      })
    })

    it('displays correct information', () => {
      const meetButton = wrapper.find('.event-action-button')
      expect(meetButton.text()).toEqual('Invite')
      expect(wrapper.vm.meetMessage(targetUser)).toMatchSnapshot()
    })

    it('initiates sending sequence', done => {
      const meetButton = wrapper.find('.event-action-button')
      const mocksendMessage = jest.fn(() => {})
      wrapper.setMethods({ sendMessage: mocksendMessage })
      meetButton.trigger('click')

      // wait a tick so button can update
      wrapper.vm.$nextTick(() => {
        expect(mocksendMessage.mock.calls).toHaveLength(1)
        done()
      })
    })
  })

  describe('no locality provided', () => {
    it('has the correct data', async () => {
      const $router = { push: jest.fn() }
      const $store = {
        commit: jest.fn(),
        getters: {
          waveHasBeenSent: () => false,
          isAuthenticated: true,
          currentUser: {
            id: '987654321',
            firstName: 'Natasha',
            childAgesInMonths: [111, 2, 2],
            locality: '',
            location: {
              lat: 41.9,
              lng: -73.6 }
          },
          distanceFromCurrentUser () {
            return 4.2
          }
        }
      }
      const $route = {
        name: 'Search'
      }

      const targetUser = {
        id: '1230',
        firstName: 'Chuck',
        lastInitial: 'D',
        childAgesInMonths: [1, 2, 3],
        location: {
          lat: 41.969880,
          lng: -73.651964 },
        employer: 'Lockheed',
        jobPosition: 'engineer'
      }
      wrapper = mount(MeetButton, {
        mocks: { $router, $store, $route },
        stubs: ['router-link'],
        propsData: {
          targetUser,
          showDescriptionModal: false,
          defaultText: 'Say Hi',
          allowUndo: false
        }
      })
      const meetButton = wrapper.find('.event-action-button')

      expect(meetButton.text()).toEqual('Say Hi')
      expect(wrapper.vm.meetMessage(targetUser)).toMatchSnapshot()
    })
  })

  describe('negative age kid', () => {
    const targetUser = {
      id: '1230',
      firstName: 'Chuck',
      lastInitial: 'D',
      childAgesInMonths: [1, 2, 3],
      location: {
        lat: 41.969880,
        lng: -73.651964 },
      employer: 'Lockheed',
      jobPosition: 'engineer'
    }

    beforeAll(async () => {
      const $router = { push: jest.fn() }
      const $store = {
        commit: jest.fn(),
        getters: {
          waveHasBeenSent: () => false,
          isAuthenticated: true,
          currentUser: {
            id: '987654321',
            firstName: 'Natasha',
            childAgesInMonths: [-1],
            locality: 'Nashville',
            location: {
              lat: 41.9,
              lng: -73.6 }
          },
          distanceFromCurrentUser () {
            return 4.2
          }
        }
      }
      const $route = {
        name: 'Search'
      }
      wrapper = mount(MeetButton, {
        mocks: { $router, $store, $route },
        stubs: ['router-link'],
        propsData: {
          targetUser,
          showDescriptionModal: false,
          defaultText: 'Wave',
          allowUndo: true
        }
      })
    })

    it('displays correct information', () => {
      const meetButton = wrapper.find('.event-action-button')
      expect(meetButton.text()).toEqual('Wave')
      expect(wrapper.vm.meetMessage(targetUser)).toMatchSnapshot()
    })

    it('initiates sending sequence', done => {
      const meetButton = wrapper.find('.event-action-button')
      const mocksendMessage = jest.fn(() => {})
      wrapper.setMethods({ sendMessage: mocksendMessage })
      meetButton.trigger('click')

      // wait a tick so button can update
      wrapper.vm.$nextTick(() => {
        expect(mocksendMessage.mock.calls).toHaveLength(1)
        done()
      })
    })
  })
})
