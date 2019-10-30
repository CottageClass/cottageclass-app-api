import Vue from 'vue'
import Vuex from 'vuex'
import auth from './auth'
import rsvp from './rsvp'
import search from './search'

import createPersistedState from 'vuex-persistedstate'

Vue.use(Vuex)

export default new Vuex.Store(
  {
    plugins: [createPersistedState()],
    modules: { auth, rsvp, search },
    state: {
      previousPath: null,
      alert: null,
      createdEvents: null,
      redirectRoute: null
    },
    mutations: {
      resetRedirectRoute: (state) => {
        state.redirectRoute = null
      },
      setRedirectRoute: (state, payload) => {
        state.redirectRoute = payload.route
      },
      showAlert: (state, payload) => {
        state.alert = payload.alert
      },
      hideAlert: (state) => {
        state.alert = null
      },
      showAlertOnNextRoute: (state, payload) => {
        state.alert = payload.alert
        state.alert.preshow = true // this indicates that we will show the alert in the next route
      },
      showAlertFromPreshow: (state) => {
        state.alert.preshow = false
      },
      clearAlert: (state) => {
        state.alert = null
      },
      setCreatedEvents: (state, payload) => {
        state.createdEvents = payload.eventData
      },
      setPreviousPath: (state, payload) => {
        state.previousPath = payload.path
      }
    },
    actions: {
      newRoute: ({ commit, state }, payload) => {
        console.log({ payload })
        if (payload.from && payload.from.path !== '/') {
          commit('setPreviousPath', { path: payload.from.path })
        } else {
          commit('setPreviousPath', { path: null })
        }
        if (state.alert) {
          if (state.alert.preshow) {
            commit('showAlertFromPreshow')
          } else {
            commit('clearAlert')
          }
        }
      }
    },
    getters: {
      previousPath: state => state.previousPath,
      alert: state => state.alert,
      redirectRoute: state => state.redirectRoute
    }
  }
)
