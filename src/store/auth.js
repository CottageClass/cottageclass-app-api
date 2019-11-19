// Vuex module to handle all the data for current user and authentication

import { fetchCurrentUser } from '@/utils/api'
import { distanceHaversine } from '@/utils/utils'
import { createUser } from '../utils/createUser'
import normalize from 'json-api-normalizer'

const state = {
  currentUser: null,
  JWT: null
}

const mutations = {
  setCurrentUser: (state, payload) => {
    state.currentUser = payload.user
  },
  setJWT: (state, payload) => {
    state.JWT = payload.JWT
  }
}

const actions = {
  updateCurrentUserFromServer: async ({ commit, state, getters }) => {
    try {
      const user = await fetchCurrentUser(getters.currentUser.id)
      commit('setCurrentUser', { user })
    } catch (e) {
      console.log('failed to fetch current user')
      console.log(e)
    }
  },
  establishUser: ({ dispatch, commit, state, getters }, payload) => {
    commit('setJWT', payload)
    if (!state.JWT) {
      commit('setCurrentUser', { user: null })
      commit('setCreatedEvents', { payload: null })
    } else {
      const currentUser = createUser(normalize(getters.parsedJWT.user))
      commit('setCurrentUser', { user: currentUser })
      if (currentUser.place) {
        dispatch('setMapArea', {
          center: { lat: currentUser.place.latitude, lng: currentUser.place.longitude },
          skipSearchUpdate: payload.skipSearchUpdate
        })
      }
    }
  }
}

const getters = {
  JWT: state => state.JWT,
  parsedJWT: state => {
    const token = state.JWT
    if (token) {
      var base64Url = token.split('.')[1]
      var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/')
      return JSON.parse(window.atob(base64))
    }
    return null
  },
  currentUser: (state) => {
    return state.currentUser
  },
  distanceFromCurrentUser: (state) => (lat, lon) => {
    if (state.currentUser) {
      return distanceHaversine(lat, lon, state.currentUser.place.latitude, state.currentUser.place.longitude)
    } else {
      return null
    }
  },
  isAuthenticated: (state) => {
    return state.currentUser !== null
  }
}

export default {
  state, mutations, actions, getters
}
