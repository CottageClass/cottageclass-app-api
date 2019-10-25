import Vue from 'vue'
// Vuex module to handle waves
const radiusSequence = [5, 10, 20]

const state = {
  mapArea: {
    shortDescription: null,
    center: { lat: 40.688309, lng: -73.994639 }, // BoCoCa
    maxDistance: 5
  },
  ageRange: { min: 0, max: 18 }
}

const mutations = {
  mutateMapArea (state, payload) {
    if (payload.center) {
      const center = {
        lat: parseFloat(payload.center.lat) || parseFloat(payload.center.lat()),
        lng: parseFloat(payload.center.lng) || parseFloat(payload.center.lng())
      }
      Vue.set(state.mapArea, 'center', center)
      Vue.set(state.mapArea, 'shortDescription', payload.shortDescription)
    }
    if (payload.miles) {
      Vue.set(state.mapArea, 'maxDistance', parseFloat(payload.miles))
    }
    if (payload.maxDistance) {
      Vue.set(state.mapArea, 'maxDistance', parseFloat(payload.maxDistance))
    }
  },
  mutateAgeRange (state, payload) {
    Vue.set(state.ageRange, 'min', parseFloat(payload.min) || null)
    Vue.set(state.ageRange, 'max', parseFloat(payload.max) || null)
  }
}

const actions = {
  async autoExpandSearchRadius ({ state, commit, dispatch }) {
    const currentRadius = state.mapArea.maxDistance
    for (let radius of radiusSequence) {
      if (radius > currentRadius) {
        commit('mutateMapArea', { maxDistance: radius })
        return dispatch('fetchItems')
      }
    }
  },
  async setMapArea ({ commit, dispatch }, payload) {
    commit('mutateMapArea', payload)
    return dispatch('fetchItems')
  },
  async setAgeRange ({ commit, dispatch }, payload) {
    commit('mutateAgeRange', payload)
    return dispatch('fetchItems')
  }
}

const getters = {
  mapArea: state => state.mapArea,
  ageRange: state => state.ageRange
}

export default {
  state, mutations, actions, getters
}
