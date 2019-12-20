import axios from 'axios'

import Logger from '@/utils/logger'
const logger = Logger('vendor:facebook')

export async function fetchFacebookImages (facebookAccessToken) {
  try {
    const url = `https://graph.facebook.com/me/photos?fields=images&access_token=${facebookAccessToken}`
    const res = await axios.get(url)
    return res.data.data
  } catch (e) {
    logger.logError(e)
    return null
  }
}

export async function facebookAccessTokenRecieved (facebookAccessToken) {

}
