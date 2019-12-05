export const createPlaceReview = (data) => {
  return createPlaceReviews(data)[0]
}

export const createPlaceReviews = (data) => {
  if (!data.placeReview) { return [] }

  const reviews = Object.values(data.placeReview).map(r => {
    const userId = r.relationships.user.data.id
    const user = data.user[userId].attributes
    return {
      ...r.attributes,
      user
    }
  })
  const sorted = reviews.sort((a, b) => {
    return new Date(b.createdAt) - new Date(a.createdAt)
  })
  return sorted
}
