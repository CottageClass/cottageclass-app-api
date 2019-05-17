// This module holds data for an event that is in the process of being created

const state = {
  event: {
    time: { err: null },
    date: { err: null },
    description: { err: null }
  }
}

const mutations = {
  setWipEvent: (state, payload) => {
    state.event = payload.event
  },
  setWipEventDate: (state, payload) => {
    state.event |= {}
    state.event.date = payload.date
  },
  setWipEventTime: (state, payload) => {
    state.event |= {}
    state.event.time = payload.time
  },
  setWipEventDescription: (state, payload) => {
    state.event |= {}
    state.event.description = payload.description
  },
  resetWipEvent: (state) => {
    state.event = {
      time: { err: null },
      date: { err: null },
      description: { err: null }
    }
  }
}
const actions = {}
const getters = {
  wipEvent: state => state.event
}

export default {
  state, mutations, actions, getters
}
