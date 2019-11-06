export const createPlace = (data) => {
  return createPlaces(data)[0]
}

export const createPlaces = (data) => {
  if (!data.place) { return [] }
  const events = data.event

  const places = Object.values(data.place).map(p => {
    const res = Object.assign({}, p.attributes)
    const eventIds = p.relationships.upcomingEvents.data.map(e => e.id)
    const upcomingEvents = eventIds.map(id => events[id].attributes)
    res.id = p.id
    res.upcomingEvents = upcomingEvents

    return res
  })
  return places
}