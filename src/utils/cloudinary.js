import axios from 'axios'

export function uploadImage (file) {
  const data = new FormData()
  data.append('file', file)
  data.append('upload_preset', 'user_images')

  return new Promise(async function (resolve, reject) {
    try {
      const res = await axios.post(
        cloudinaryUploadUrl(),
        data,
        { headers: { 'Content-Type': 'multipart/form-data' } }
      )
      console.log({ res })
      resolve(res.data.secure_url)
    } catch (e) {
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
