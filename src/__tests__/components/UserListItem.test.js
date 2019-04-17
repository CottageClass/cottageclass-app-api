import { mount } from '@vue/test-utils'
import UserListItem from '@/components/UserListItem.vue'

describe('UserListItem', () => {
  let wrapper

  beforeAll(async () => {
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

    wrapper = mount(UserListItem, {
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
  })

  it('displays correct information', () => {
    const name = wrapper.find('.name')
    const children = wrapper.find('.children')
    const distance = wrapper.find('.distance')
    const profession = wrapper.find('.profession')
    expect(name.text()).toBe('Chuck')
    expect(children.text()).toBe('3 kids (1, 2, 3)')
    expect(distance.text()).toBe('0.6mi')
    expect(profession.text()).toBe('Engineer, Lockheed')
  })
})
