import { mount } from '@vue/test-utils'
import UserListItem from '@/components/UserListItem.vue'

describe('UserListItem', () => {
  const $store = {
    getters: {
      waveHasBeenSent: () => false,
      mapArea: {
        center: {
          lat: 41.96,
          lng: -73.65
        },
        maxDistance: 5
      },
      currentUser: {
        id: '987654321',
        firstName: 'Natasha',
        childAgesInMonths: [1, 2, 3],
        locality: 'Nashville',
        location: {
          lat: 41.9,
          lng: -73.6 }
      }
    }
  }

  it('displays correct information', () => {
    const wrapper = mount(UserListItem, {
      mocks: { $store },
      stubs: ['router-link'],
      propsData: {
        user: {
          id: '123456789',
          firstName: 'Chuck',
          lastInitial: 'D',
          childAgesInMonths: [99, -1, 3],
          location: {
            lat: 41.969880,
            lng: -73.651964 },
          employer: 'Lockheed',
          jobPosition: 'engineer'
        }
      }
    })

    const name = wrapper.find('.username')

    const children = wrapper.find('.number-of-kids')
    const distance = wrapper.find('.distance')
    const profession = wrapper.find('.occupation')
    const fbVerified = wrapper.find('.badge-verified')

    expect(name.text()).toBe('Chuck')
    expect(children.text()).toBe('2 kids (3 mos, 8)')
    expect(distance.text()).toBe('0.6mi')
    expect(profession.text()).toBe('Engineer, Lockheed')
    expect(fbVerified.exists()).toBeFalsy()
  })

  it('shows verified badge', () => {
    const wrapper = mount(UserListItem, {
      mocks: { $store },
      stubs: ['router-link'],
      propsData: {
        user: {
          id: '123456789',
          firstName: 'Chuck',
          lastInitial: 'D',
          childAgesInMonths: [1, 2, 3],
          location: {
            lat: 41.969880,
            lng: -73.651964 },
          employer: 'Lockheed',
          jobPosition: 'engineer',
          facebookUid: '1234567890'
        }
      }
    })

    const name = wrapper.find('.username')

    const distance = wrapper.find('.distance')
    const profession = wrapper.find('.occupation')
    const fbVerified = wrapper.find('.badge-verified')

    expect(name.text()).toBe('Chuck')
    expect(distance.text()).toBe('0.6mi')
    expect(profession.text()).toBe('Engineer, Lockheed')
    expect(fbVerified.exists()).toBeTruthy()
  })
})
