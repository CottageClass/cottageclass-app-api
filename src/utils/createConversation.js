export const createConversations = (data) => {
  if (!data.conversation) { return [] }

  const conversations = Object.values(data.conversation).map(c => {
    let partner, message
    if (data.user) {
      const userId = c.relationships.partner.data.id
      partner = data.user[userId].attributes
    }
    if (data.message) {
      const messageId = c.relationships.lastMessage.data.id
      message = data.message[messageId].attributes
    }
    return {
      message,
      partner
    }
  })
  const sorted = conversations.sort((a, b) => {
    return new Date(b.message.createdAt) - new Date(a.message.createdAt)
  })
  return sorted
}
