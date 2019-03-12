// Vuex module to handle all the data for current user and authentication

import { distanceHaversine, fetchCurrentUser } from '@/utils/api'

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
  establishUser: ({ commit, state, getters }, payload) => {
    commit('setJWT', payload)
    console.log({payload})
    if (!state.JWT) {
      commit('setCurrentUser', { user: null })
    } else {
      const userId = getters.parsedJWT.sub
      return fetchCurrentUser(userId).then(user => {
        commit('setCurrentUser', { user })
      })
    }
  }
}

const getters = {
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
    return ADMIN_WHITELIST.includes(state.currentUser.email)
  }
}

export default {
  state, mutations, actions, getters
}
