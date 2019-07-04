export const createChildcareRequest = (data) => {
  return createChildcareRequests(data)[0]
}

export const createChildcareRequests = (data) => {
  if (!data.childcareRequest) { return [] }
  const ids = Object.keys(data.childcareRequest)

  return ids.map(id => {
    const res = { id }
    Object.assign(res, data.childcareRequest[id].attributes)
    return res
  })
}
