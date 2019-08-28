import {
  submitUserInfo
} from '@/utils/api/users'
import mockAxios from 'axios'

describe('users', () => {
  describe('submitUserInfo', () => {
    // try each of the attributes indivudually and make sure the post method is called
    // with the appropriate object
    it.each([
      [{ images: 'example.com/images/fake.png' },
        { images: 'example.com/images/fake.png' }],
      [{ phone: { number: '(609)-216-4398' } },
        { phoneAreaCode: '609', phoneNumber: '2164398' }],
      [{ availability: { availableMornings: true } }, { availableMornings: true }],
      [{ profileBlurb: 'Hi, I am bio' }, { profileBlurb: 'Hi, I am bio' }],
      [{ jobPosition: 'doctor' }, { jobPosition: 'doctor' }],
      [{ employer: 'hospital' }, { employer: 'hospital' }],
      [{ languages: 'lang' }, { languages: 'lang' }],
      [{ hasPet: 'hpet' }, { hasPet: 'hpet' }],
      [{ houseRules: 'hrules' }, { houseRules: 'hrules' }],
      [{ children: [{ age: '2', name: 'Chuck' }, { name: 'Ahh', age: '4' }] },
        { childrenAttributes: [{ age: '2', name: 'Chuck', parentId: '1230' },
          { age: '4', name: 'Ahh', parentId: '1230' }] }],
      [{ location: {
        lat: '432',
        lng: '978',
        fullAddress: {
          street_number: '234',
          route: 'Main st.',
          locality: 'Worcester',
          sublocality: 'sublo',
          neighborhood: 'Biotech Park Area',
          administrative_area_level_1: 'Massachusetts',
          administrative_area_level_2: 'Worcester County',
          country: 'USA',
          postal_code: '12345' }
      }
      }, {
        admin_area_level_1: 'Massachusetts',
        admin_area_level_2: 'Worcester County',
        country: 'USA',
        latitude: '432',
        locality: 'Worcester',
        longitude: '978',
        neighborhood: 'Biotech Park Area',
        postalCode: '12345',
        route: 'Main st.',
        streetNumber: '234',
        sublocality: 'sublo'
      }]
    ])('data: %o', async (data, expected) => {
      await submitUserInfo('1230', data)
      expect(mockAxios.put).toHaveBeenCalledWith('/api/users/1230', expected)
    })
  })
})
