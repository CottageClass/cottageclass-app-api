import { mount } from '@vue/test-utils'
import SearchListCard from '@/components/search/SearchListCard'

describe('SearchListCard', () => {
  it('mounts with just user info', () => {
    const wrapper = mount(SearchListCard, {
      propsData: {
        user: {
          firstName: 'Foo',
          lastInitial: 'B'
        },
        mapCenter: { lat: 42.2798695, lng: -71.7898409 }
      }
    })
    const userName = wrapper.find('.user-info__name')

    expect(userName.text()).toBe('Foo B.')
  })
})
