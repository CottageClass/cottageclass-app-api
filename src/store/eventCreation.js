// This module holds data for an event that is in the process of being created

const state = {
  event: {
    availability: { err: null },
    date: { err: null },
    description: { err: null }
  }
}

const mutations = {
  setWipEvent: (state, payload) => {
    state.event = payload.event
  },
  resetWipEvent: (state) => {
    state.event = {
      availability: { err: null },
      date: { err: null },
      description: { err: null }
    }
  }
}
const actions = {}
const getters = {
  wipEventContiguousTimeBlocks (state) {
    if (state.event.availability.availability) {
      let startTime = null
      const blocks = []
      state.event.availability.availability.forEach((day, dayIndex) => {
        day.forEach((selected, hourIndex) => {
          if (selected && !startTime) {
            // beginning of block
            startTime = 24 * dayIndex + hourIndex
          }
          if (!selected && startTime) {
            // end of block
            blocks.push([startTime, 24 * dayIndex + hourIndex])
            startTime = null
          }
        })
      })
      return blocks
    }
    return []
  },
  wipEvent: state => state.event
}

export default {
  state, mutations, actions, getters
}
