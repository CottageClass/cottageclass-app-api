import axios from 'axios'
import Logger from '@/utils/logger'
import { isIOSNativeApp } from '@/utils/platform'

// use a differnt axios instance so as to not use the authorization interceptor
const cloudinaryAxios = axios.create()
const logger = Logger('vendor:cloudinary')

export function avatarUrl (rawUrl, size) {
  if (rawUrl.includes('g_custom')) {
    return rawUrl.replace('/upload/', `/upload/c_thumb,g_custom,h_${size},w_${size}/`)
  }
  return rawUrl.replace('/upload/', `/upload/c_thumb,z_0.8,h_${size},w_${size}/`)
}

export function householdImageUrl (rawUrl, size) {
  return rawUrl.replace('/upload/', `/upload/c_thumb,g_custom,h_${size},w_${size}/`)
}

export function lightboxImageUrl (rawUrl) {
  return rawUrl.replace('/upload/', `/upload/g_custom/`)
}

export function imageUrl (rawUrl, options) {
  let transformations = ''

  if (options.height) {
    transformations += `h_${options.height}`
  }
  if (options.width) {
    transformations += `w_${options.width}`
  }
  return rawUrl.replace('/upload/', `/upload/${transformations}/`)
}

export function createWidget (callback, options) {
  const sources = ['local', 'url']
  if (!isIOSNativeApp()) {
    sources.push('camera')
  }

  const widgetOptions = {
    cloudName: process.env.CLOUDINARY_CLOUD_NAME,
    uploadPreset: 'user_images',
    cropping: true,
    showSkipCropButton: false,
    croppingDefaultSelectionRatio: 0.9,
    showPoweredBy: false, // maybe this will work if we ever pay for cloudinary
    sources,
    ...options
  }
  return window.cloudinary.createUploadWidget(widgetOptions, callback)
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
