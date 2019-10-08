export const itemPlace = (item) => {
  return (item.event && item.event.place) || (item.user && item.user.place)
}

export const itemPosition = (item) => {
  const lat = itemPlace(item).latitude || itemPlace(item).fuzzyLatitude
  const lng = itemPlace(item).longitude || itemPlace(item).fuzzyLongitude
  return { lat, lng }
}

export const itemRoute = (item) => {
  let name, id
  if (item.event) {
    name = 'EventPage'
    id = item.event.id
  } else {
    name = 'UserPage'
    id = item.user.id
  }
  return { name, params: { id } }
}
