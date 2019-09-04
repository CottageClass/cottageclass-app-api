const event2186 = require('./__mockData__/event_2186.json')
const allEvents = require('./__mockData__/all_events.json')
const user1230Events = require('./__mockData__/user_1230_events.json')
const user1230 = require('./__mockData__/user_1230.json')
const user1228 = require('./__mockData__/user_1228.json')
const user1281 = require('./__mockData__/user_1281.json')
const nearbyUsers = require('./__mockData__/nearbyUsers.json')
const noNearbyUsers = require('./__mockData__/noNearbyUsers.json')
const fewNearbyUsers = require('./__mockData__/fewNearbyUsers.json')

export default {
  create: jest.fn(() => {
    return this
  }),
  get: jest.fn((url) => {
    const eventUrl = `/api/events/`
    const userUrl = `/api/users/`
    if (url === eventUrl + '2186') {
      return Promise.resolve(event2186)
    }
    if (url === eventUrl || url === eventUrl + 'upcoming') {
      return Promise.resolve(allEvents)
    }
    if (url === eventUrl + 'upcoming/miles/10/latitude/42.2798738/longitude/-71.7900378/page/1/page_size/100') {
      return Promise.resolve(allEvents)
    }
    if (url === userUrl + `1230/events/created/upcoming/page/1/page_size/100`) {
      return Promise.resolve(user1230Events)
    }
    if (url.includes('/events/created/upcoming/page/1/page_size/100')) {
      return Promise.resolve(user1230Events)
    }
    if (url === userUrl + `miles/10/latitude/42.2798738/longitude/-71.7900378/page/1/page_size/100`) {
      return Promise.resolve(nearbyUsers)
    }

    if (url === userUrl + `miles/10/latitude/40.2798738/longitude/-71.7900378/page/1/page_size/100`) {
      return Promise.resolve(noNearbyUsers)
    }

    if (url === userUrl + `miles/10/latitude/41.2798738/longitude/-71.7900378/page/1/page_size/100`) {
      return Promise.resolve(fewNearbyUsers)
    }

    // this is the unauthenticated endpont
    if (url === `/api/users/1230`) {
      return Promise.resolve(user1230)
    }
    if (url === `/api/users/1281`) {
      return Promise.resolve(user1281)
    }

    // this is the authenticated endpont
    if (url === `/api/users/1228`) {
      return Promise.resolve(user1228)
    }
  }),
  post: jest.fn((url, data) => {
    if (url === 'api/users/000/stars') {
      return Promise.reject(Error('no such user'))
    }
    if (url === 'api/users/000/dark_stars') {
      return Promise.reject(Error('no such user'))
    }
    return Promise.resolve({ status: 200 })
  }),
  delete: jest.fn((url, data) => {
    if (url === 'api/users/000/stars') {
      return Promise.reject(Error('no such user'))
    }
    if (url === 'api/users/000/dark_stars') {
      return Promise.reject(Error('no such user'))
    }
    return Promise.resolve({ status: 200 })
  }),
  put: jest.fn((url, data) => {
    return Promise.resolve({ status: 200 })
  })
}
