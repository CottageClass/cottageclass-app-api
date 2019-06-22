import {
  fetchEvent,
  fetchEvents,
  fetchUpcomingEvents,
  submitUserInfo
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
      expect(events.length).toBe(666)
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
  describe('submitUserInfo', () => {
    it('sends image data', async () => {
      let data = { images: 'example.com/images/fake.png' }
      await submitUserInfo('1230', data)
    })
  })
})
