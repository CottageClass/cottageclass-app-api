import { mount } from '@vue/test-utils'
import SearchListCard from '@/components/search/SearchListCard'

describe('SearchListCard', () => {
  const $store = {
    getters: {
      waveHasBeenSent: () => false,
      currentUser: { id: 100000 },
      isAuthenticated: false
    }
  }
  it('mounts with just user info', () => {
    const wrapper = mount(SearchListCard, {
      mocks: { $store },
      propsData: {
        user: {
          id: 12,
          firstName: 'Foo',
          lastInitial: 'B',
          jobPosition: 'Doctor',
          employer: 'New York Health Dept.',
          profileBlurb: 'This is my biography and I love it.',
          childAgesInMonths: [4, 30, 108],
          availableMornings: true,
          availableAfternoons: false,
          availableWeekends: true,
          availableEvenings: false,
          fuzzyLatitude: 42.27,
          fuzzyLongitude: -71.78,
          images: [
            'https://res.cloudinary.com/cottageclass2/image/upload/v1559762128/user_images/2012-04-06_21.02.13_egjide.png',
            'https://res.cloudinary.com/cottageclass2/image/upload/v1559762128/user_images/2012-04-06_21.02.13_egjide.png',
            'https://res.cloudinary.com/cottageclass2/image/upload/v1559762152/user_images/2012-09-06_19.16.29_gehvr5.png',
            'https://res.cloudinary.com/cottageclass2/image/upload/v1559762152/user_images/2012-09-06_19.16.29_gehvr5.png',
            'https://res.cloudinary.com/cottageclass2/image/upload/v1559762128/user_images/2012-04-06_21.02.13_egjide.png',
            'https://res.cloudinary.com/cottageclass2/image/upload/v1559762152/user_images/2012-09-06_19.16.29_gehvr5.png'
          ]
        },
        mapCenter: { lat: 42.2798695, lng: -71.7898409 }
      }
    })
    const userName = wrapper.find('.user-info__name')
    const occupation = wrapper.find('.user-info__occupation')
    const description = wrapper.find('.description-text')
    const kidsAges = wrapper.find('.user-info__kids')
    const date = wrapper.find('.header__date')
    const distance = wrapper.find('.header__distance')
    const badge = wrapper.find('.badge-verified')
    const householdImages = wrapper.findAll('.household-container .tiny-photo')
    const moreImagesLabel = wrapper.find('.household-container .more-images-label')

    expect(userName.text()).toBe('Foo B.')
    expect(occupation.text()).toBe('Doctor, New York Health Dept.')
    expect(description.text()).toBe('This is my biography and I love it.')
    expect(kidsAges.text()).toBe('Ages 4 mos, 2 and 9')
    expect(date.text()).toBe('Available mornings and weekends')
    expect(distance.text()).toBe('0.7 mi')
    expect(badge.exists()).toBe(false)
    expect(householdImages).toHaveLength(3)
    expect(moreImagesLabel.text()).toBe('3 more')
  })

  it('some alternative cases on the data', () => {
    const wrapper = mount(SearchListCard, {
      mocks: { $store },
      propsData: {
        user: {
          id: 22,
          facebookUid: '563930223',
          childAgesInMonths: [1],
          location: { lat: 42.27, lng: -71.78 },
          images: []
        },
        mapCenter: { lat: 42.2798695, lng: -71.7898409 }
      }
    })
    const kidsAges = wrapper.find('.user-info__kids')
    const badge = wrapper.find('.badge-verified')
    const householdImages = wrapper.findAll('.household-container .tiny-photo')
    const moreImagesLabel = wrapper.find('.household-container .more-images-label')

    expect(kidsAges.text()).toBe('1 child age 1 mo')
    expect(badge.exists()).toBe(true)
    expect(householdImages).toHaveLength(0)
    expect(moreImagesLabel.text()).toBe('')
  })

  it('allows no center', () => {
    const wrapper = mount(SearchListCard, {
      mocks: { $store },
      propsData: {
        user: {
          id: 22
          // facebookUid: '563930223',
          // childAgesInMonths: [1],
          // location: { lat: 42.27, lng: -71.78 },
          // images: []
        }
      }
    })
    const distance = wrapper.find('.header__distance')
    expect(distance.exists()).toBe(false)
  })
})
