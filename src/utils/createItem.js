import { createUsers } from '@/utils/createUser'
import { createEvents } from '@/utils/createEvent'

export const createItem = (data) => {
  return createItems(data)[0]
}

export const createItemsFromEvents = (data) => {
  if (!data.event) {
    return []
  }
  const events = createEvents(data)

  const items = events.map(event => {
    return { event, user: event.user }
  })
  if (data.meta.event) {
    const order = data.meta.event.data.map(u => u.id)
    return order.map(id => items.find(i => i.event.id === id))
  }
  return items
}

export const createItems = (data) => {
  if (!data.searchListItem || data.searchListItem.length === 0) {
    return []
  }
  const users = createUsers(data)
  const events = createEvents(data)

  const itemIds = Object.keys(data.searchListItem)

  const items = itemIds.map(itemId => {
    const item = data.searchListItem[itemId]
    const res = { id: itemId }
    const user = users.find(u => {
      return u.id === item.relationships.user.data.id
    })
    Object.assign(res, { user })
    if (item.relationships.itemable.data) {
      if (item.relationships.itemable.data.type === 'event') {
        const event = events.find(e => e.id === item.relationships.itemable.data.id)
        Object.assign(res, { event })
      }
    }
    return res
  })
  if (data.meta.item) {
    const order = data.meta.item.data.map(u => u.id)
    return order.map(id => items.find(i => i.id === id))
  }
  return items
}
