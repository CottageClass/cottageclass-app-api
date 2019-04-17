import { mount } from '@vue/test-utils'
import MeetButton from '@/components/base/MeetButton.vue'

describe('MeetButton', () => {
  let wrapper

  beforeAll(async () => {
    const $store = {
      getters: {
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
    const requestMessages = [
      `Hi Chuck, I'm a parent in Nashville and I'd love to meet up for a playdate. When might be a good time? -Natasha`,
      `(Natasha has 3 kids ages 1, 2 & 3, lives 4.2 miles from you, and their profile is here: https://kidsclub.io/user/987654321. Good luck & enjoy! ❤️ KidsClub.io)`
    ]

    expect(meetButton.text()).toEqual('Meet')
    expect(wrapper.vm.meetMessages[0]).toEqual(requestMessages[0])
    expect(wrapper.vm.meetMessages[1]).toEqual(requestMessages[1])
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
