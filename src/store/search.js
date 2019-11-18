import Vue from 'vue'
import { fetchUsers, fetchEvents } from '@/utils/api'
import filter from './filter'

const state = {
  itemType: 'Events',
  data: {}
}

const mutations = {
  setItemType (state, payload) {
    state.itemType = payload.itemType
    const data = state.data[state.itemType]
    if (!data) {
      Vue.set(state.data, state.itemType)
    }
  },
  setPageItems (state, payload) {
    if (!state.data[state.itemType]) {
      Vue.set(state.data, state.itemType, baseData())
    }
    Vue.set(state.data[state.itemType].pages, payload.page, payload.items)
  },
  incrementLastPage (state) {
    const data = state.data[state.itemType]
    data.lastPage = data.lastPage + 1
  },
  setMoreAvailable (state, payload) {
    const data = state.data[state.itemType]
    data.moreAvailable = payload.moreAvailable
  },
  updateUser (state, payload) {
    const user = payload.user
    for (let key in state.data) {
      const data = state.data[key]
      const userItems = data.items.filter(i => i.user.id.toString() === user.id.toString())
      for (const item of userItems) {
        Vue.set(item, 'user', user)
      }
    }
  },
  updateEvent (state, payload) {
    const event = payload.event
    for (let key in state) {
      const data = state.data[key]
      const eventItems = data.items.filter(i => i.event && i.event.id === event.id)
      for (const item of eventItems) {
        Vue.set(item, 'event', event)
      }
    }
  },
  ensureState (state) {
    const data = state.data[state.itemType]
    if (!data) {
      Vue.set(state.data, state.itemType, baseData())
      Vue.set(state.data[state.itemType], 'searchHasSucceeded', false)
    }
  },
  setSearchHasSucceeded (state, payload) {
    Vue.set(state.data[state.itemType], 'searchHasSucceeded', payload.succeeded)
  },
  resetFetchLocks (state) {
    const keys = Object.keys(state.data)
    keys.forEach(k => {
      Vue.set(state.data[k], 'fetchLock', false)
    })
  },
  setFetchLock (state, payload) {
    Vue.set(state.data[state.itemType], 'fetchLock', payload.lock)
  },
  resetToBaseState (state) {
    const searchHasSucceeded = state.data[state.itemType].searchHasSucceeded
    Vue.set(state.data, state.itemType, baseData())
    Vue.set(state.data[state.itemType], 'searchHasSucceeded', searchHasSucceeded)
  }
}

const actions = {
  async fetchItems ({ state, commit, dispatch }) {
    commit('ensureState')
    if (state.data[state.itemType].fetchLock) { return }
    try {
      commit('setFetchLock', { lock: true })
      commit('resetToBaseState')
    } finally {
      commit('setFetchLock', { lock: false })
    }
    return dispatch('fetchMoreItems')
  },

  async fetchMoreItems ({ state, commit, getters, dispatch }) {
    if (state.data[state.itemType].fetchLock) { return }
    commit('setFetchLock', { lock: true })
    const data = state.data[state.itemType]
    const page = data.lastPage
    const params = {
      pageSize: 10,
      minAge: getters.ageRange.min,
      maxAge: getters.ageRange.max,
      miles: getters.mapArea.maxDistance,
      lat: getters.mapArea.center.lat,
      lng: getters.mapArea.center.lng,
      date: getters.eventTime.date,
      weekday: getters.eventTime.weekday,
      page: page + 1 // API is 1-indexed
    }

    commit('ensureState')
    let items
    try {
      switch (state.itemType) {
        case 'Events':
          items = await fetchEvents(params)
          break
        case 'Parents':
          items = await fetchUsers(params)
          break
      }
    } finally {
      commit('setFetchLock', { lock: false })
    }
    commit('incrementLastPage')
    commit('setMoreAvailable', { moreAvailable: items.length >= params.pageSize })
    if (items.length > 0) {
      commit('setSearchHasSucceeded', { succeeded: true })
    } else if (!state.data[state.itemType].searchHasSucceeded) {
      dispatch('expandRadiusAndFetchAgain')
    }
    commit('setPageItems', { items, page })
  },

  async expandRadiusAndFetchAgain ({ dispatch }) {
    dispatch('autoExpandSearchRadius')
  }
}

const getters = {
  currentData: state => key => state.data[state.itemType],
  items (state) {
    const data = state.data[state.itemType]
    try {
      if (data.pages.length === 0) {
        return null
      }
      return data.pages.reduce((items, page) => {
        return items.concat(page)
      }, [])
    } catch (e) {
      return null
    }
  },
  showFetchMoreButton: state => {
    try { return state.data[state.itemType].moreAvailable } catch (e) { return false }
  },
  itemType: state => state.itemType
}

const modules = { filter }

export default {
  state, mutations, actions, getters, modules
}

function baseData () {
  return {
    lastPage: 0,
    moreAvailable: false,
    pages: [],
    fetchLock: false
  }
}
