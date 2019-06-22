import normalize from 'json-api-normalizer'

export * from './stars'
export * from './search'
export * from './auth'
export * from './proxy'
export * from './users'
export * from './events'
export * from './notifications'

export async function fetchFacebookImages (facebookAccessToken) {
  try {
    const res = await axios.get(`https://graph.facebook.com/me/photos?fields=images&access_token=${facebookAccessToken}`)
    return res.data.data
  } catch (e) {
    logger.logError(e)
    return null
  }
}
