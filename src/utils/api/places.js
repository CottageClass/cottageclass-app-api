import axios from 'axios'

export function submitGooglePlaceIdAndFetchOurOwn (googlePlaceId) {
  const place = { google_id: googlePlaceId, public: true }
  return axios.post(`api/places/`, place).then(res => {
    return res.data.data.id
  })
}
