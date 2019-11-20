import { createComments } from '@/utils/createComment.js'
import normalize from 'json-api-normalizer'

describe('createPlace', () => {
  it('processes incoming data', () => {
    const rawData = {
      'data': [
        {
          'id': '1',
          'type': 'comment',
          'attributes': {
            'content': 'what up worcester'
          },
          'relationships': {
            'sender': {
              'data': {
                'id': '84',
                'type': 'sender'
              }
            }
          }
        },
        {
          'id': '2',
          'type': 'comment',
          'attributes': {
            'content': 'what up worcester'
          },
          'relationships': {
            'sender': {
              'data': {
                'id': '84',
                'type': 'sender'
              }
            }
          }
        },
        {
          'id': '3',
          'type': 'comment',
          'attributes': {
            'content': 'what up worc'
          },
          'relationships': {
            'sender': {
              'data': {
                'id': '84',
                'type': 'sender'
              }
            }
          }
        }
      ],
      'included': [
        {
          'id': '84',
          'type': 'user',
          'attributes': {
            'id': 84,
            'avatar': 'https://res.cloudinary.com/cottageclass2/image/upload/v1574199349/wky8qjiaofdabsaw4mud.jpg',
            'first_name': 'Ari',
            'verified': false,
            'images': [],
            'languages': [],
            'job_position': 'facebooker',
            'employer': null,
            'highest_education': null,
            'school': null,
            'facebook_uid': '10161426358710224',
            'twitter_user': null,
            'linkedin_user': null,
            'created_at': '2019-11-13T22:28:30.156Z',
            'child_ages_in_months': [
              44
            ],
            'profile_blurb': 'playgrounds',
            'activities': [],
            'available_mornings': true,
            'available_afternoons': false,
            'available_evenings': false,
            'available_weekends': false,
            'instagram_user': null,
            'last_initial': 'K',
            'starred': false,
            'dark_starred': false
          },
          'relationships': {
            'children': {
              'data': [
                {
                  'id': '101',
                  'type': 'child'
                }
              ]
            },
            'place': {
              'data': {
                'id': '156',
                'type': 'place'
              }
            }
          }
        }
      ]
    }

    const data = normalize(rawData)
    const comments = createComments(data)
    expect(comments.length).toEqual(3)
    expect(comments[0].content).toEqual('what up worcester')
    expect(comments[0].sender.avatar).toEqual('https://res.cloudinary.com/cottageclass2/image/upload/v1574199349/wky8qjiaofdabsaw4mud.jpg')
  })
})
