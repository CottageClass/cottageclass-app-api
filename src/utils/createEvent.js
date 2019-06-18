import moment from 'moment'
import { capitalize } from './utils'

export const createEvent = (data) => {
  const id = Object.keys(data.event)[0]
  const event = data.event[id]
  const attributes = cleanEvent(event.attributes)

  const participatingChildren = event.relationships.participants.data.map(e => e.id)
  let participatingParents
  if (data.participant) {
    participatingParents = Object.values(data.participant).map(p => cleanPerson(p.attributes))
  } else {
    participatingParents = []
  }

  return {
    data,
    id,
    ...attributes,
    participatingChildren,
    participatingParents
  }
}

export const createEvents = (data, sortFunction) => {
  if (!data.event) {
    return []
  }
  const all = Object.values(data.event).map(e => {
    let participatingParents
    if (data.participant) {
      participatingParents = e.relationships.participants.data.map(p => {
        return cleanPerson(data.participant[p.id])
      })
    } else {
      participatingParents = []
    }
    return {
      id: e.id,
      participatingParents,
      ...cleanEvent(e.attributes)
    }
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
  res.hostId = attributes.hostId.toString()
  res.startsAt = moment(attributes.startsAt)
  res.endsAt = moment(attributes.endsAt)
  res.hostFirstName = capitalize(attributes.hostFirstName)
  res.hostFuzzyLatitude = parseFloat(attributes.hostFuzzyLatitude)
  res.hostFuzzyLongitude = parseFloat(attributes.hostFuzzyLongitude)
  res.activityName = attributes.activityNames.length > 0 ? attributes.activityNames[0] : null
  res.food = attributes.foods.length > 0 ? attributes.foods[0] : null
  if (attributes.host && attributes.host.data) {
    res.host = attributes.host.data.attributes
  }
  return res
}

function cleanPerson (attributes) {
  const res = Object.assign({}, (attributes))
  res.userFuzzyLatitude = parseFloat(attributes.userFuzzyLatitude)
  res.userFuzzyLongitude = parseFloat(attributes.userFuzzyLongitude)
  res.userFirstName = capitalize(attributes.userFirstName)
  return res
}
