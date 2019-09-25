import Vue from 'vue'
// Vuex module to handle waves

const state = {
  items: null,
  lastPage: 0,
  mapArea: {
    center: { lat: 40.688309, lng: -73.994639 }, // BoCoCa
    maxDistance: 5
  }
}

const mutations = {
  resetItems (state) {
    state.items = null
    state.lastPage = 0
  },
  setMapArea (state, payload) {
    if (payload.center) {
      const center = {
        lat: parseFloat(payload.center.lat),
        lng: parseFloat(payload.center.lng)
      }
      Vue.set(state.mapArea, 'center', center)
    }
    Vue.set(state.mapArea, 'maxDistance', parseFloat(payload.maxDistance) || state.mapArea.maxDistance)
  },
  resetFeed (state) {
    state = {
      items: null,
      lastPage: 0
    }
  },
  addItems (state, payload) {
    const items = payload.items
    if (!state.items) {
      state.items = []
    }
    state.items = state.items.concat(items)
  },
  incrementLastPage (state) {
    state.lastPage = state.lastPage + 1
  },
  updateUser (state, payload) {
    const user = payload.user
    const userItems = state.items.filter(i => i.user.id === user.id)
    for (const item of userItems) {
      item.user = user
    }
  },
  updateEvent (state, payload) {
    const event = payload.event
    const eventIndex = state.items.findIndex(i => i.event.id === event.id)
    state.items[eventIndex].event = event
  }
}

const actions = {
}

const getters = {
  mapArea: state => state.mapArea,
  items: state => state.items,
  lastPage: state => state.lastPage
}

export default {
  state, mutations, actions, getters
}
