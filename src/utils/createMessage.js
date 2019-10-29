export const createMessages = (data) => {
  console.log({ data })
  if (!data.message) { return [] }

  const messages = Object.values(data.message).map(m => {
    return m.attributes
  })
  return messages
}
