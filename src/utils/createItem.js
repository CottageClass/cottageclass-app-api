import { createUsers } from '@/utils/createUser'

export const createItem = (data) => {
  return createItems(data)[0]
}

export const createItems = (data) => {
  const items = createUsers(data)
  for (let item of items) {
    item.event = null
  }
  return items
}
