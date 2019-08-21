// Vuex module to handle waves

const state = {
  pendingWaves: [],
  sentWaves: []
}

const mutations = {
  markWaveSent: (state, payload) => {
    const id = payload.targetUserId.toString()
    if (state.pendingWaves.some(user => user.id === id)) {
      state.pendingWaves = state.pendingWaves.filter(w => w.id !== id)
      state.sentWaves.push(id)
    }
  },
  removePendingWave: (state, payload) => {
    const id = payload.targetUserId
    state.pendingWaves = state.pendingWaves.filter(w => w.id !== id)
  },
  addPendingWave: (state, payload) => {
    state.pendingWaves.push(payload.targetUser)
  },
  addSentWave: (state, payload) => {
    state.sentWaves.push(payload.targetUserId.toString())
  }
}

const actions = {
}

const getters = {
  pendingWaves: state => state.pendingWaves,
  waveHasBeenSent: state => {
    return (userId) => state.sentWaves.includes(userId)
  }
}

export default {
  state, mutations, actions, getters
}
