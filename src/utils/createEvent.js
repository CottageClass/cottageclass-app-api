import moment from 'moment'
import { capitalize } from './utils'

export const createEvent = (data) => {
  return createEvents(data)[0]
}

export const createEvents = (data, sortFunction) => {
  if (!data.event) {
    return []
  }
  const all = Object.values(data.event).map(e => {
    let participatingParents, place, user
    if (data.participant) {
      participatingParents = e.relationships.participants.data.map(p => {
        return cleanPerson(data.participant[p.id])
      })
    } else {
      participatingParents = []
    }
    if (data.user) {
      const userId = e.relationships.user.data.id
      console.log({ userId })
      user = cleanPerson(data.user[userId].attributes)
    }

    if (data.place) {
      const placeId = e.relationships.place.data.id
      place = data.place[placeId].attributes
    }
    console.log({ user })
    const res = {
      user,
      place,
      id: e.id,
      participatingParents,
      ...cleanEvent(e.attributes)
    }
    return res
  })

  // if no sort method is given, sort by id ascending (use int value, not lexiacal)
  sortFunction = sortFunction || (e => parseInt(e.id))
  // use this to sort by distance or
  const sorted = all.sort((a, b) => sortFunction(a) - sortFunction(b))
  sorted.all = all

  return sorted
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

function cleanPerson (attributes) {
  const res = Object.assign({}, (attributes))
  res.userFuzzyLatitude = parseFloat(attributes.userFuzzyLatitude)
  res.userFuzzyLongitude = parseFloat(attributes.userFuzzyLongitude)
  res.userFirstName = capitalize(attributes.userFirstName)
  return res
}
