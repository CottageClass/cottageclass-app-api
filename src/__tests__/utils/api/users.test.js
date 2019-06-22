import {
  submitUserInfo
} from '@/utils/api/users'
import mockAxios from 'axios'

describe('users', () => {
  describe('submitUserInfo', () => {
    it('sends image data', async () => {
      let data = { images: 'example.com/images/fake.png' }
      await submitUserInfo('1230', data)
      expect(mockAxios.post).toHaveBeenCalledTimes(1)
    })
  })
})
