export const createChildcareRequest = (data) => {
  const res = {}
  const content = Object.values(data.childcareRequest)[0].attributes.content
  const id = Object.values(data.childcareRequest)[0].id
  const userId = Object.values(data.childcareRequest)[0].relationships.user.data.id
  const user = data.user[userId].attributes
  Object.assign(res, { content, id, user })

  return res
}
