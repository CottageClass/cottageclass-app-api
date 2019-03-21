import Vue from 'vue'
import Vuex from 'vuex'
import auth from './auth'
import createPersistedState from 'vuex-persistedstate'
import events from './events'

Vue.use(Vuex)

export default new Vuex.Store(
  {
    plugins: [createPersistedState()],
    modules: { events, auth },
    state: {
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
      }
    },
    actions: {
      newRoute: ({ commit, state }) => {
        // this method manages the showing of alerts when you enter a new route
        // TODO these should be committed with mutations
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
      alert: state => state.alert,
      firstCreatedEvent: (state, getters) => {
        if (state.createdEvents) {
          return state.createdEvents[0]
        } else {
          return null
        }
      },
      firstCreatedEventId: (state) => {
        if (state.createdEvents) {
          return state.createdEvents[0].id
        } else {
          return null
        }
      },
      redirectRoute: state => state.redirectRoute
    }
  }
)
