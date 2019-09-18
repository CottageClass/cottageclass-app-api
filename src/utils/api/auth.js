import axios from 'axios'
import firebaseWrapper from '@/utils/vendor/firebase'
import { postMessage } from '@/utils/iosAdapter'
// import Logger from '@/utils/logger'

// const logger = Logger('api:auth')

// request an email with a password change link
export function submitPasswordResetRequest (data) {
  return axios.post('/users/password', data)
}

// submit a new password to be changed
export function submitNewPassword (params) {
  return axios.put('/users/password', params)
}

// sign up as a new user
export function register (params) {
  return axios.post(`/users`, params)
}

export function signIn (params) {
  return axios.post(`/users/sign_in`, { user: params }).then((res) => {
    if (res.status.toString() === '200') {
      const userId = res.data[1].sub
      const messageContents = {
        title: 'signInComplete'
      }
      postMessage(messageContents) // post a message to ios to request push
      firebaseWrapper.init(userId) // initialize firebase to watch for token
      return res
    }
  })
}

// destroy the current session on the server
export function signOut () {
  return axios.delete(`/users/sign_out`)
}

export function deleteUserAccount (params) {
  return axios.delete(`api/users/${params.id}`)
}
