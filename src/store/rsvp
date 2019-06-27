// This module holds data for an event that is in the process of being created

const state = {
  declinedRsvps: []
}

const mutations = {
  declineRsvp: (state, payload) => {
    state.declinedRsvps.push(payload.eventId.toString())
  }
}
const actions = {}
const getters = {
  isRsvpDeclined: state => {
    return (eventId) => state.declinedRsvps.includes(eventId.toString())
  }
}

export default {
  state, mutations, actions, getters
}
