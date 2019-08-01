// This module stores data around modal

const state = {
  modal: null
}

const mutations = {
  showModal: (state, payload) => {
    state.modal = payload.modal
  },
  hideModal: (state) => {
    state.modal = null
  }
}
const actions = {}
const getters = {
  modal: state => state.modal
}

export default {
  state, mutations, actions, getters
}
