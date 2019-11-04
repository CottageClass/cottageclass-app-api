import moment from 'moment'
import { parsePlace } from '@/utils/parsePlace'

export const createEvent = (data) => {
  return createEvents(data)[0]
}

export const createEvents = (data, sortFunction) => {
  console.log({ data })
  if (!data.event) {
    return []
  }
  const all = Object.values(data.event).map(e => {
    let participatingParents, place, user
    if (data.participant) {
      participatingParents = e.relationships.participants.data.map(p => {
        return data.participant[p.id]
      })
    } else {
      participatingParents = []
    }
    if (data.user) {
      const userId = e.relationships.user.data.id
      user = data.user[userId].attributes
    }

    if (data.place) {
      const placeId = e.relationships.place.data.id
      place = parsePlace(data.place[placeId].attributes)
      place.id = placeId
    }
    const res = {
      user,
      place,
      id: e.id,
      participatingParents,
      ...cleanEvent(e.attributes)
    }
    return res
  })

  if (data.meta.event) {
    const order = data.meta.event.data.map(u => u.id)
    return order.map(id => all.find(i => i.id === id))
  }

  return all
}

/*
 * Sanitizing helper methods
*/
function cleanEvent (attributes) {
  const res = Object.assign({}, (attributes))
  res.startsAt = moment(attributes.startsAt)
  res.endsAt = moment(attributes.endsAt)
  return res
}
