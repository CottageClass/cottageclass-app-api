import { capitalize } from '@/utils/utils'
import { parsePlace } from '@/utils/parsePlace'

export const createUser = (data) => {
  return createUsers(data)[0]
}

export const createUsers = (data) => {
  if (!data.user) { return [] }
  const includedChildren = data.child || []
  const ids = Object.keys(data.user)

  return ids.map(id => {
    const p = data.user[id].attributes
    const childIds = data.user[id].relationships.children.data.map(e => e.id)
    const placeId = data.user[id].relationships.place.data && data.user[id].relationships.place.data.id
    let place = placeId && data.place && parsePlace(data.place[placeId].attributes)
    if (place) {
      place.id = placeId
    }
    let event = null
    const children = childIds.map(id => parseChildData(includedChildren[id])).filter(c => !!c)
    const hasAllRequiredFields = !!(p.phone && place)
    const activities = (p.activities || []).map(activity => activity.replace(/_/g, ' '))

    const firstName = p.firstName && capitalize(p.firstName)
    return {
      ...p,
      firstName,
      id,
      place,
      lastInitial: capitalize(p.lastInitial) || capitalize(p.lastName[0]),
      activities,
      networkCode: 'brooklyn-events', // give everyone the new network code
      location,
      facebookMapIcon: 'https://graph.facebook.com/' + p.facebook_uid + '/picture?width=30',
      children,
      event,
      hasAllRequiredFields
    }
  })
}

const parseChildData = (c) => {
  if (!c) { return null }
  const attributes = c.attributes
  attributes.firstName = attributes.firstName && capitalize(attributes.firstName)
  return {
    id: c.id,
    emergencyContacts: c.relationships.emergencyContacts && c.relationships.emergencyContacts.data.map(e => e.id),
    ...attributes
  }
}
