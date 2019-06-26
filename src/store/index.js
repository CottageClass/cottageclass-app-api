import Vue from 'vue'
import Vuex from 'vuex'
import auth from './auth'
import rsvp from './rsvp'
import eventCreation from './eventCreation'
import createPersistedState from 'vuex-persistedstate'

Vue.use(Vuex)

export default new Vuex.Store(
  {
    plugins: [createPersistedState()],
    modules: { auth, eventCreation, rsvp },
    state: {
      alert: null,
      modal: null,
      createdEvents: null,
      redirectRoute: null,
      mapArea: {
        center: { lat: 40.688309, lng: -73.994639 }, // BoCoCa
        maxDistance: 5
      },
      pendingWaves: [],
      sentWaves: []
    },
    mutations: {
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
      },
      resetRedirectRoute: (state) => {
        state.redirectRoute = null
      },
      setRedirectRoute: (state, payload) => {
        state.redirectRoute = payload.route
      },
      showModal: (state, payload) => {
        state.modal = payload.modal
      },
      hideModal: (state) => {
        state.modal = null
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
      modal: state => state.modal,
      alert: state => state.alert,
      firstCreatedEvent: (state, getters) => {
        if (state.createdEvents) {
          return state.createdEvents[0]
        } else {
          return null
        }
      },
      pendingWaves: state => state.pendingWaves,
      waveHasBeenSent: state => {
        return (userId) => state.sentWaves.includes(userId)
      },
      mapArea: state => state.mapArea,
      redirectRoute: state => state.redirectRoute
    }
  }
)
