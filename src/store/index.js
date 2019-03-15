import Vue from 'vue'
import Vuex from 'vuex'
import * as api from '../utils/api'
import moment from 'moment'
import auth from './auth'
import createPersistedState from 'vuex-persistedstate'
import _ from 'lodash'

Vue.use(Vuex)

const DEFAULT_REDIRECT_PATH = '/home'

export default new Vuex.Store(
  {
    plugins: [createPersistedState()],
    modules: {
      auth
    },
    state: {
      alert: null,
      createdEvents: null,
      RSVPAttempEventId: null,
      redirectPath: DEFAULT_REDIRECT_PATH
    },
    mutations: {
      resetRedirectPath: (state) => {
        state.redirectPath = DEFAULT_REDIRECT_PATH
      },
      setRedirectPath: (state, payload) => {
        state.redirectPath = payload.path
      },
      showAlert: (state, payload) => {
        state.alert = payload.alert
      },
      setRSVPAttemptEventId: (state, payload) => {
        state.RSVPAttempEventId = payload.id
      },
      hideAlert: (state) => {
        state.alert = null
      },
      showAlertOnNextRoute: (state, payload) => {
        state.alert = payload.alert
        state.alert.preshow = true // this indicates that we will show the alert in the next route
      },
      setCreatedEvents: (state, payload) => {
        state.createdEvents = payload.eventData
      }
    },
    actions: {
      newRoute: ({ commit, state }, { to, from, next }) => {
        // this method manages the showing of alerts when you enter a new route
        // TODO these should be committed with mutations
        if (state.alert) {
          if (state.alert.preshow) {
            state.alert.preshow = false
          } else {
            state.alert = null
          }
        }
        next()
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
      rsvpAttemptedId: state => state.RSVPAttempEventId,
      redirectPath: state => state.redirectPath
    }
  }
)
