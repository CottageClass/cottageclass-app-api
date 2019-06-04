import axios from 'axios'
import Logger from '@/utils/logger'

// use a differnt axios instance so as to not use the authorization interceptor
const cloudinaryAxios = axios.create()

const logger = Logger('api')

export function uploadImage (file) {
  const data = new FormData()
  data.append('file', file)
  data.append('upload_preset', 'user_images')

  return new Promise(async function (resolve, reject) {
    try {
      const res = await cloudinaryAxios.post(
        cloudinaryUploadUrl(),
        data,
        { headers: { 'Content-Type': 'multipart/form-data' } }
      )
      logger.log('cloudinary upload success')
      resolve(res.data.secure_url)
    } catch (e) {
      logger.logError('cloudinary upload error')
      reject(e)
    }
  }
  )
}

function cloudinaryUploadUrl () {
  return `https://api.cloudinary.com/v1_1/${
    process.env.CLOUDINARY_CLOUD_NAME
  }/image/upload`
}
