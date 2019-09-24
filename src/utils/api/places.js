import axios from 'axios'
import normalize from 'json-api-normalizer'

export function submitGooglePlaceIdAndFetchOurOwn (googlePlaceId) {
  const place = { google_id: googlePlaceId, public: true }
  return axios.post(`api/places/${place}`).then(res => {
    return normalize(res.data)
  })
}
