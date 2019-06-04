import axios from 'axios'
import Logger from '@/utils/logger'

// use a differnt axios instance so as to not use the authorization interceptor
const cloudinaryAxios = axios.create()

const logger = Logger('cloudinary')

export function avatarUrl (rawUrl, size) {
  return rawUrl.replace('/upload/', `/upload/c_thumb,g_face,h_${size},w_${size}/`)
}

export async function uploadAvatarImage (file) {
  const res = await upload(file)
  const rawUrl = res.data.url
  const url = rawUrl.replace('/upload/', '/upload/c_thumb,g_face,h_360,w_360/')
  return url
}

export async function uploadImage (file) {
  try {
    const res = await upload(file)
    logger.log('cloudinary upload success')
    return res.data.secure_url
  } catch (e) {
    logger.logError('cloudinary upload error')
    throw e
  }
}

function upload (file) {
  const data = new FormData()
  data.append('file', file)
  data.append('upload_preset', 'user_images')
  return cloudinaryAxios.post(
    cloudinaryUploadUrl(),
    data,
    { headers: { 'Content-Type': 'multipart/form-data' } }
  )
}

function cloudinaryUploadUrl () {
  return `https://api.cloudinary.com/v1_1/${
    process.env.CLOUDINARY_CLOUD_NAME
  }/image/upload`
}
