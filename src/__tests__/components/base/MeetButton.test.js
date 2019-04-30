import { mount } from '@vue/test-utils'
import MeetButton from '@/components/base/MeetButton.vue'

describe('MeetButton', () => {
  let wrapper

  describe('locality provided', () => {
    beforeAll(async () => {
      const $store = {
        getters: {
          isAuthenticated: true,
          currentUser: {
            id: '987654321',
            firstName: 'Natasha',
            childAges: [1, 2, 3],
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
        mocks: { $store },
        stubs: ['router-link'],
        propsData: {
          targetUser: {
            id: '123456789',
            firstName: 'Chuck',
            lastInitial: 'D',
            childAges: [1, 2, 3],
            location: {
              lat: 41.969880,
              lng: -73.651964 },
            employer: 'Lockheed',
            jobPosition: 'engineer'
          },
          fillStyle: 'outline',
          layoutStyle: 'slim'
        }
      })
    })

    it('displays correct information', () => {
      const meetButton = wrapper.find('.meet-button')
      const requestMessage = `Natasha (https://kidsclub.io/users/987654321) waved at you! They live 4.2 mi. away with 3 kids age 1, 2 & 3. If you're interested in a playdate, reply here!`

      expect(meetButton.text()).toEqual('Wave')
      expect(wrapper.vm.meetMessage).toEqual(requestMessage)
    })

    it('initiates sending sequence', done => {
      const meetButton = wrapper.find('.meet-button')
      const mocksendMessage = jest.fn(() => {})
      wrapper.setMethods({ sendMessage: mocksendMessage })
      meetButton.trigger('click')

      // wait a tick so button can update
      wrapper.vm.$nextTick(() => {
        expect(mocksendMessage.mock.calls).toHaveLength(0)
        expect(meetButton.text()).toEqual('Undo')
        done()
      })
    })
  })

  describe('no locality provided', () => {
    it('has the correct data', async () => {
      const $store = {
        getters: {
          isAuthenticated: true,
          currentUser: {
            id: '987654321',
            firstName: 'Natasha',
            childAges: [1, 2, 3],
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

      wrapper = mount(MeetButton, {
        mocks: { $store },
        stubs: ['router-link'],
        propsData: {
          targetUser: {
            id: '123456789',
            firstName: 'Chuck',
            lastInitial: 'D',
            childAges: [1, 2, 3],
            location: {
              lat: 41.969880,
              lng: -73.651964 },
            employer: 'Lockheed',
            jobPosition: 'engineer'
          },
          fillStyle: 'outline',
          layoutStyle: 'slim'
        }
      })
      const meetButton = wrapper.find('.meet-button')
      const requestMessage = `Natasha (https://kidsclub.io/users/987654321) waved at you! They live 4.2 mi. away with 3 kids age 1, 2 & 3. If you're interested in a playdate, reply here!`

      expect(meetButton.text()).toEqual('Wave')
      expect(wrapper.vm.meetMessage).toEqual(requestMessage)
    })
  })

  describe('negative age kid', () => {
    beforeAll(async () => {
      const $store = {
        getters: {
          isAuthenticated: true,
          currentUser: {
            id: '987654321',
            firstName: 'Natasha',
            childAges: [-1],
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
        mocks: { $store },
        stubs: ['router-link'],
        propsData: {
          targetUser: {
            id: '123456789',
            firstName: 'Chuck',
            lastInitial: 'D',
            childAges: [1, 2, 3],
            location: {
              lat: 41.969880,
              lng: -73.651964 },
            employer: 'Lockheed',
            jobPosition: 'engineer'
          },
          fillStyle: 'outline',
          layoutStyle: 'slim'
        }
      })
    })

    it('displays correct information', () => {
      const meetButton = wrapper.find('.meet-button')
      const requestMessage = `Natasha (https://kidsclub.io/users/987654321) waved at you! They live 4.2 mi. away. If you're interested in a playdate, reply here!`

      expect(meetButton.text()).toEqual('Wave')
      expect(wrapper.vm.meetMessage).toEqual(requestMessage)
    })

    it('initiates sending sequence', done => {
      const meetButton = wrapper.find('.meet-button')
      const mocksendMessage = jest.fn(() => {})
      wrapper.setMethods({ sendMessage: mocksendMessage })
      meetButton.trigger('click')

      // wait a tick so button can update
      wrapper.vm.$nextTick(() => {
        expect(mocksendMessage.mock.calls).toHaveLength(0)
        expect(meetButton.text()).toEqual('Undo')
        done()
      })
    })
  })
})
