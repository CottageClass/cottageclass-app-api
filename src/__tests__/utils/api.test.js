import {
  fetchEvent,
  fetchEvents,
  fetchUpcomingEventsWithinDistance,
  fetchUpcomingEvents,
  fetchUser,
  submitUserInfo,
  fetchUsersWithinDistance
} from '@/utils/api'
import mockAxios from 'axios'

describe('events', () => {
  describe('fetchEvent', () => {
    it('has the right data', async () => {
      const event = await fetchEvent('2186')
      expect(mockAxios.get).toHaveBeenCalledTimes(1)
      expect(event.data).toMatchSnapshot()
    })
    it('throws an error with a bad id', async () => {
      await expect(fetchEvent(123123)).rejects.toEqual(Error('failed to fetch event'))
    })
  })

  describe('fetchEvents', () => {
    it('has the right data', async () => {
      const events = await fetchEvents()
      expect(typeof events.all).toBe('object')
      expect(events.length).toBe(33)
      expect(events).toMatchSnapshot()
    })
  })

  describe('fetchUpcomingEventsWithinDistance', () => {
    it('has the right data', async () => {
      const events = await fetchUpcomingEventsWithinDistance({ miles: 10, lat: 42.2798738, lng: -71.7900378 })
      expect(events[0].id).toBe('2353')
      expect(events).toMatchSnapshot()
    })
  })

  describe('fetchUpcomingEvents for user', () => {
    it('has the right data', async () => {
      const events = await fetchUpcomingEvents(1230)
      expect(events[0].id).toBe('2359')
      expect(events).toMatchSnapshot()
    })
  })
})

describe('users', () => {
  describe('fetchUsersWithinDistance', () => {
    it('has the right data', async () => {
      const users = await fetchUsersWithinDistance({ miles: 10, lat: 42.2798738, lng: -71.7900378 })
      expect(users.length).toBe(7)
    })
  })
  describe('fetchUser', () => {
    it('has the right data', async () => {
      const user = await fetchUser('1230')
      expect(user.id).toBe('1230')
    })
  })
  describe('submitUserInfo', () => {
    it('sends image data', async () => {
      let data = { images: 'example.com/images/fake.png' }
      await submitUserInfo('1230', data)
    })
  })
})
