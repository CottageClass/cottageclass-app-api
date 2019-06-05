import { mount } from '@vue/test-utils'
import SearchListCard from '@/components/search/SearchListCard'

describe('SearchListCard', () => {
  it('mounts with just user info', () => {
    const wrapper = mount(SearchListCard, {
      propsData: {
        user: {
          firstName: 'Foo',
          lastInitial: 'B',
          jobPosition: 'Doctor',
          employer: 'New York Health Dept.',
          profileBlurb: 'This is my biography and I love it.',
          childAgesInMonths: [4, 30, 108],
          availableMornings: true,
          availableAfternoons: false,
          availableWeekends: true,
          availableEvenings: false
        },
        mapCenter: { lat: 42.2798695, lng: -71.7898409 }
      }
    })
    const userName = wrapper.find('.user-info__name')
    const occupation = wrapper.find('.user-info__occupation')
    const description = wrapper.find('.description-text')
    const kidsAges = wrapper.find('.user-info__kids')
    const date = wrapper.find('.header__date')

    expect(userName.text()).toBe('Foo B.')
    expect(occupation.text()).toBe('Doctor, New York Health Dept.')
    expect(description.text()).toBe('This is my biography and I love it.')
    expect(kidsAges.text()).toBe('Ages 4mos, 2 and 11')
    expect(date.text()).toBe('Available mornings and weekends')
  })
})
