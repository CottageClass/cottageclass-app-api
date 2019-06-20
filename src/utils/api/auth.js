import axios from 'axios'

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
  return axios.post(`/users/sign_in`, { user: params })
}

// destroy the current session on the server
export function signOut () {
  return axios.delete(`/users/sign_out`)
}
