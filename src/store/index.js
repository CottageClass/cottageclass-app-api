import Vue from 'vue'
import Vuex from 'vuex'
import auth from './auth'
import rsvp from './rsvp'
import eventCreation from './eventCreation'
import waves from './waves'
import createPersistedState from 'vuex-persistedstate'

Vue.use(Vuex)

export default new Vuex.Store(
  {
    plugins: [createPersistedState()],
    modules: { auth, eventCreation, rsvp, waves },
    state: {
      alert: null,
      createdEvents: null,
      redirectRoute: null,
      mapArea: {
        center: { lat: 40.688309, lng: -73.994639 }, // BoCoCa
        maxDistance: 5
      }
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
      setMapArea: (state, payload) => {
        // this can be accomplished with Object.assign ?
        state.mapArea.center = payload.center || state.mapArea.center
        state.mapArea.maxDistance = payload.maxDistance || state.mapArea.maxDistance
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
      mapArea: state => state.mapArea,
      redirectRoute: state => state.redirectRoute
    }
  }
)
