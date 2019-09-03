import { unstarUser, starUser, darkStarUser, undarkStarUser } from '@/utils/api'
import mockAxios from 'axios'

describe('star', () => {
  describe('starUser', () => {
    it('hits the api', async () => {
      try {
        await starUser('123')
        expect(mockAxios.post).toHaveBeenCalledWith('api/users/123/stars')
      } catch (e) {
      }
    })
    it('errors correctly', () => {
      return starUser('000').catch(e => {
        expect(e).toEqual(Error('no such user'))
      })
    })
  })
  describe('unstarUser', () => {
    it('hits the api', async () => {
      try {
        await unstarUser('123')
        expect(mockAxios.delete).toHaveBeenCalledWith('api/users/123/stars')
      } catch (e) {
      }
    })
    it('errors correctly', () => {
      return unstarUser('000').catch(e => {
        expect(e).toEqual(Error('no such user'))
      })
    })
  })
})

describe('dark star', () => {
  describe('undarkStarUser', () => {
    it('hits the api', async () => {
      try {
        await undarkStarUser('123')
        expect(mockAxios.delete).toHaveBeenCalledWith('api/users/123/dark_stars')
      } catch (e) {
      }
    })
    it('errors correctly', () => {
      return undarkStarUser('000').catch(e => {
        expect(e).toEqual(Error('no such user'))
      })
    })
  })
  describe('darkStarUser', () => {
    it('hits the api', async () => {
      try {
        await darkStarUser('123')
        expect(mockAxios.post).toHaveBeenCalledWith('api/users/123/dark_stars')
      } catch (e) {
      }
    })
    it('errors correctly', () => {
      return darkStarUser('000').catch(e => {
        expect(e).toEqual(Error('no such user'))
      })
    })
  })
})
