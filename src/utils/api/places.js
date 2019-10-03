import axios from 'axios'

export function submitGooglePlaceIdAndFetchOurOwn (googlePlaceId, isPublic = false) {
  const place = { google_id: googlePlaceId, public: isPublic }
  return axios.post(`api/places/`, place).then(res => {
    return res.data.data.id
  })
}
