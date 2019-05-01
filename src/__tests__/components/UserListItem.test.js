import { mount } from '@vue/test-utils'
import UserListItem from '@/components/UserListItem.vue'

describe('UserListItem', () => {
  const $store = {
    getters: {
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
        childAges: [1, 2, 3],
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
          childAges: [1, 2, 3],
          location: {
            lat: 41.969880,
            lng: -73.651964 },
          employer: 'Lockheed',
          jobPosition: 'engineer'
        }
      }
    })

    const name = wrapper.find('.name')

    const children = wrapper.find('.children')
    const distance = wrapper.find('.distance')
    const profession = wrapper.find('.profession')
    const fbVerified = wrapper.find('.facebook-verified-badge')

    expect(name.text()).toBe('Chuck')
    expect(children.text()).toBe('3 kids (1, 2, 3)')
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
          childAges: [1, 2, 3],
          location: {
            lat: 41.969880,
            lng: -73.651964 },
          employer: 'Lockheed',
          jobPosition: 'engineer',
          facebookUid: '1234567890'
        }
      }
    })

    const name = wrapper.find('.name')

    const children = wrapper.find('.children')
    const distance = wrapper.find('.distance')
    const profession = wrapper.find('.profession')
    const fbVerified = wrapper.find('.facebook-verified-badge')

    expect(name.text()).toBe('Chuck')
    expect(children.text()).toBe('3 kids (1, 2, 3)')
    expect(distance.text()).toBe('0.6mi')
    expect(profession.text()).toBe('Engineer, Lockheed')
    expect(fbVerified.exists()).toBeTruthy()
  })
})
