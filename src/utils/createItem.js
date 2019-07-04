import { createUsers } from '@/utils/createUser'
import { createEvents } from '@/utils/createEvent'
import { createChildcareRequests } from '@/utils/createChildcareRequest'

export const createItem = (data) => {
  return createItems(data)[0]
}

export const createItems = (data) => {
  const users = createUsers(data)
  const events = createEvents(data)
  const childcareRequests = createChildcareRequests(data)

  const itemIds = Object.keys(data.searchListItem)
  const items = itemIds.map(itemId => {
    const item = data.searchListItem[itemId]
    const res = { id: itemId }
    const user = users.find(u => {
      return u.id === item.relationships.user.data.id
    })
    Object.assign(res, { user })
    if (item.relationships.itemable.data.type === 'event') {
      const event = events.find(e => e.id === item.relationships.itemable.data.id)
      Object.assign(res, { event })
    } else if (item.relationships.itemable.data.type === 'childcareRequest') {
      const childcareRequest = childcareRequests.find(cr => cr.id === item.relationships.itemable.data.id)
      Object.assign(res, { childcareRequest })
    }
    return res
  })
  if (data.meta.item) {
    const order = data.meta.item.data.map(u => u.id)
    return order.map(id => items.find(i => i.id === id))
  }
  return items
}
