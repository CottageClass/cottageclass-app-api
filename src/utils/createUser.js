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
    let groups = []
    if (data.user[id].relationships.userGroups) {
      groups = data.user[id].relationships.userGroups.data.map(e => e.id)
    }
    let childIds = []
    if (data.user[id].relationships.children) {
      childIds = data.user[id].relationships.children.data.map(e => e.id)
    }
    const placeId = data.user[id].relationships.place.data && data.user[id].relationships.place.data.id
    let place = placeId && data.place && parsePlace(data.place[placeId].attributes)
    if (place) {
      place.id = placeId
    }
    let event = null
    const children = childIds.map(id => parseChildData(includedChildren[id])).filter(c => !!c)
    const hasAllRequiredFields = !!(p.phone && place && children && children.length > 0)

    const firstName = p.firstName && capitalize(p.firstName)
    return {
      ...p,
      firstName,
      id,
      place,
      lastInitial: capitalize(p.lastInitial) || capitalize(p.lastName[0]),
      networkCode: 'brooklyn-events', // give everyone the new network code
      location,
      facebookMapIcon: 'https://graph.facebook.com/' + p.facebook_uid + '/picture?width=30',
      children,
      event,
      hasAllRequiredFields,
      groups
    }
  })
}

const parseChildData = (c) => {
  if (!c) { return null }
  const attributes = c.attributes
  attributes.firstName = attributes.firstName && capitalize(attributes.firstName)
  return {
    id: c.id,
    ...attributes
  }
}
