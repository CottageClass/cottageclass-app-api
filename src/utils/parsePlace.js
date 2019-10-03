export const parsePlace = (place) => {
  if (place) {
    place.fuzzyLatitude = parseFloat(place.fuzzyLatitude)
    place.fuzzyLongitude = parseFloat(place.fuzzyLongitude)
  }
  return place
}
