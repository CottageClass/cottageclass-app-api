import { createUsers } from '@/utils/createUser'

export const createComment = (data) => {
  return createComments(data)[0]
}

export const createComments = (data) => {
  if (!data.comment) { return [] }

  const users = createUsers(data)

  const comments = Object.values(data.comment).map(p => {
    const id = p.id
    const senderId = p.relationships.sender.data.id
    const sender = users.find(u => u.id === senderId)
    return { ...p.attributes, sender, id }
  })
  return comments
}
