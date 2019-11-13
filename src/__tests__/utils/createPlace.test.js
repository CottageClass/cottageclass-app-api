import { createPlace } from '@/utils/createPlace.js'
import normalize from 'json-api-normalizer'

describe('createPlace', () => {
  it('processes incoming data', () => {
    const rawData = { 'data': {
      'id': '150',
      'type': 'place',
      'attributes': {
        'public': false,
        'locality': 'Worcester',
        'vicinity': 'Worcester',
        'sublocality': null,
        'neighborhood': 'Biotech Park Area',
        'admin_area_level_1': 'Massachusetts',
        'admin_area_level_2': null,
        'fuzzy_latitude': '42.278250065845',
        'fuzzy_longitude': '-71.7906304745404',
        'postal_code': null,
        'country': 'United States',
        'name': '43 Orne St',
        'description': 'funnest place in the world',
        'images': ['http://www.example.com/pic.jpg']
      },
      'relationships': {
        'upcoming_events': {
          'data': [
            {
              'id': '550',
              'type': 'upcoming_event'
            },
            {
              'id': '548',
              'type': 'upcoming_event'
            },
            {
              'id': '547',
              'type': 'upcoming_event'
            },
            {
              'id': '546',
              'type': 'upcoming_event'
            },
            {
              'id': '549',
              'type': 'upcoming_event'
            }
          ]
        }
      }
    },
    'included': [
      {
        'id': '550',
        'type': 'event',
        'attributes': {
          'name': 'asdf',
          'images': [
            'https://res.cloudinary.com/cottageclass2/image/upload/c_thumb,g_custom/v1572986680/ilh4xluwzr16cqzz0ekd.jpg',
            'https://res.cloudinary.com/cottageclass2/image/upload/v1573008553/uvboncycbu8qd7hntxaa.jpg'
          ],
          'description': '',
          'maximum_children': 4,
          'child_age_minimum': 0,
          'child_age_maximum': 0,
          'starts_at': '2019-11-07T00:45:00-05:00',
          'ends_at': '2019-11-07T03:00:00-05:00',
          'participants_count': 0,
          'full': false
        },
        'relationships': {
          'participants': {
            'data': []
          },
          'place': {
            'data': {
              'id': '150',
              'type': 'place'
            }
          },
          'user': {
            'data': {
              'id': '78',
              'type': 'user'
            }
          }
        }
      },
      {
        'id': '548',
        'type': 'event',
        'attributes': {
          'name': 'fff',
          'images': [],
          'description': '',
          'maximum_children': 4,
          'child_age_minimum': 0,
          'child_age_maximum': 0,
          'starts_at': '2019-11-13T02:00:00-05:00',
          'ends_at': '2019-11-13T03:00:00-05:00',
          'participants_count': 0,
          'full': false
        },
        'relationships': {
          'participants': {
            'data': []
          },
          'place': {
            'data': {
              'id': '150',
              'type': 'place'
            }
          },
          'user': {
            'data': {
              'id': '78',
              'type': 'user'
            }
          }
        }
      },
      {
        'id': '547',
        'type': 'event',
        'attributes': {
          'name': 'dsa',
          'images': [
            'https://res.cloudinary.com/cottageclass2/image/upload/v1572902957/zasrziw8guoizwvhrawk.jpg'
          ],
          'description': '',
          'maximum_children': 4,
          'child_age_minimum': 0,
          'child_age_maximum': 0,
          'starts_at': '2019-11-13T03:00:00-05:00',
          'ends_at': '2019-11-13T04:00:00-05:00',
          'participants_count': 0,
          'full': false
        },
        'relationships': {
          'participants': {
            'data': []
          },
          'place': {
            'data': {
              'id': '150',
              'type': 'place'
            }
          },
          'user': {
            'data': {
              'id': '78',
              'type': 'user'
            }
          }
        }
      },
      {
        'id': '546',
        'type': 'event',
        'attributes': {
          'name': 'asdf',
          'images': [
            'https://res.cloudinary.com/cottageclass2/image/upload/c_thumb,g_custom/v1572901855/lcpoc05ty1x6erssgl23.jpg'
          ],
          'description': '',
          'maximum_children': 4,
          'child_age_minimum': 0,
          'child_age_maximum': 0,
          'starts_at': '2019-11-14T00:00:00-05:00',
          'ends_at': '2019-11-14T01:00:00-05:00',
          'participants_count': 0,
          'full': false
        },
        'relationships': {
          'participants': {
            'data': []
          },
          'place': {
            'data': {
              'id': '150',
              'type': 'place'
            }
          },
          'user': {
            'data': {
              'id': '78',
              'type': 'user'
            }
          }
        }
      },
      {
        'id': '549',
        'type': 'event',
        'attributes': {
          'name': 'asdf',
          'images': [
            'https://res.cloudinary.com/cottageclass2/image/upload/c_thumb,g_custom/v1572986468/iuow1e19ooqojbibzzpa.jpg'
          ],
          'description': '',
          'maximum_children': 4,
          'child_age_minimum': 0,
          'child_age_maximum': 0,
          'starts_at': '2019-11-19T00:00:00-05:00',
          'ends_at': '2019-11-19T02:00:00-05:00',
          'participants_count': 0,
          'full': false
        },
        'relationships': {
          'participants': {
            'data': []
          },
          'place': {
            'data': {
              'id': '150',
              'type': 'place'
            }
          },
          'user': {
            'data': {
              'id': '78',
              'type': 'user'
            }
          }
        }
      },
      {
        'id': '78',
        'type': 'user',
        'attributes': {
        },
        'relationships': {
        }
      }
    ]
    }
    const data = normalize(rawData)
    const place = createPlace(data)
    expect(place.id).toEqual('150')
    expect(place.upcomingEvents).toHaveLength(5)
    expect(place.description).toEqual('funnest place in the world')
    expect(place.images).toEqual(['http://www.example.com/pic.jpg'])
  })
})
