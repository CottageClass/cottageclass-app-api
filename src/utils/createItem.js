import { createUsers } from '@/utils/createUser'
import { createEvents } from '@/utils/createEvent'

export const createItem = (data) => {
  return createItems(data)[0]
}

export const createItems = (data) => {
  const users = createUsers(data)
  const events = createEvents(data)
  const items = users.map((user) => {
    let event = null
    if (data.user[user.id].relationships.showcaseEvent && data.user[user.id].relationships.showcaseEvent.data) {
      const eventId = data.user[user.id].relationships.showcaseEvent.data.id
      event = events.find(e => e.id === eventId)
    }
    return { event, user }
  })
  return items
}
