// Vuex module to handle all the data for current user and authentication

import { distanceHaversine, fetchCurrentUser } from '@/utils/api'
import { createUser } from '../utils/createUser'
import normalize from 'json-api-normalizer'

const ADMIN_WHITELIST = [
  'holmes@cottageclass.com',
  'manisha@cottageclass.com',
  'developer@cottageclass.com',
  'asa@cottageclass.com'
]

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
  establishUser: ({ commit, state, getters }, payload) => {
    commit('setJWT', payload)
    if (!state.JWT) {
      commit('setCurrentUser', { user: null })
      commit('setCreatedEvents', { payload: null })
    } else {
      const currentUser = createUser(normalize(getters.parsedJWT.user))
      commit('setCurrentUser', { user: currentUser })
      commit('setMapArea', {
        center: { lat: currentUser.latitude, lng: currentUser.longitude },
        maxDistance: 5
      })
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
      return distanceHaversine(lat, lon, state.currentUser.latitude, state.currentUser.longitude)
    } else {
      return null
    }
  },
  isAuthenticated: (state) => {
    return state.currentUser !== null
  },
  isAdminUser: (state) => {
    return !!state.currentUser && ADMIN_WHITELIST.includes(state.currentUser.email)
  }
}

export default {
  state, mutations, actions, getters
}
