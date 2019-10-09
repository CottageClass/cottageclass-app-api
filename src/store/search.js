import Vue from 'vue'
import { fetchFeed, fetchEvents } from '@/utils/api'
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
  resetSearch (state) {
    Vue.set(state.data, state.itemType, baseData())
  },
  addItems (state, payload) {
    const items = payload.items
    if (!state.data[state.itemType]) {
      Vue.set(state.data, state.itemType, baseData())
    }
    if (!state.data[state.itemType].items) {
      Vue.set(state.data[state.itemType], 'items', [])
    }
    Vue.set(state.data[state.itemType], 'items', state.data[state.itemType].items.concat(items))
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
    }
  }
}

const actions = {
  async fetchItems ({ state, commit, dispatch }) {
    if (state.data[state.itemType].alreadyFetching) { return }
    commit('resetSearch')
    Vue.set(state.data[state.itemType], 'alreadyFetching', true)
    const results = await dispatch('fetchMoreItems')
    Vue.delete(state.data[state.itemType], 'alreadyFetching')
    return results
  },

  async fetchMoreItems ({ state, commit, getters }) {
    const data = state.data[state.itemType]
    const params = {
      pageSize: 10,
      minAge: getters.ageRange.min,
      maxAge: getters.ageRange.max,
      miles: getters.mapArea.maxDistance,
      lat: getters.mapArea.center.lat,
      lng: getters.mapArea.center.lng,
      page: data.lastPage + 1
    }

    commit('ensureState')
    let items
    switch (state.itemType) {
      case 'Events':
        items = await fetchEvents(params)
        break
      case 'Parents':
        items = await fetchFeed(params)
        break
    }
    commit('incrementLastPage')
    commit('setMoreAvailable', { moreAvailable: items.length >= params.pageSize })
    commit('addItems', { items })
  }
}

const getters = {
  currentData: state => key => state.data[state.itemType],
  items: state => {
    try { return state.data[state.itemType].items } catch (e) { return null }
  },
  showFetchMoreButton: state => state.data[state.itemType].moreAvailable
}

const modules = { filter }

export default {
  state, mutations, actions, getters, modules
}

function baseData () {
  return {
    lastPage: 0,
    moreAvailable: false
  }
}
