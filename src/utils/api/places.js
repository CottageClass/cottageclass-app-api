import axios from 'axios'

export function submitGooglePlaceIdAndFetchOurOwn (googlePlaceId, isPublic = false, apartmentNumber) {
  const place = { google_id: googlePlaceId, public: isPublic, apartment_number: apartmentNumber }
  return axios.post(`api/places/`, place).then(res => {
    return res.data.data.id
  })
}
