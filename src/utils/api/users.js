import { createUser, createUsers } from '../createUser'
import axios from 'axios'
import normalize from 'json-api-normalizer'

import Logger from '@/utils/logger'
const logger = Logger('api:users')

export function submitUserInfo (userId, data) {
  if (!data) { return }

  let { phone, location, availability, images } = data

  let postData = {}
  if (location && location.fullAddress) {
    let address = location.fullAddress
    let {
      street_number,
      route,
      locality,
      administrative_area_level_1,
      administrative_area_level_2,
      sublocality,
      neighborhood,
      country,
      postal_code
    } = address

    postData = {
      streetNumber: street_number,
      route: route,
      locality: locality,
      // snake_case key name is ugly but necessary for backend to recognize attr with trailing 1
      admin_area_level_1: administrative_area_level_1,
      admin_area_level_2: administrative_area_level_2,
      sublocality,
      neighborhood,
      country: country,
      postalCode: postal_code,
      latitude: location.lat,
      longitude: location.lng
    }
  }

  if (location && location.apartmentNumber) {
    postData = {
      ...postData,
      apartmentNumber: location.apartmentNumber
    }
  }

  if (phone && phone.number) {
    let phoneAreaCode = phone.number.match(/(\(\d+\))/)[0].replace(/[^\d]/g, '')
    let phoneNumber = phone.number.match(/\d{3}-\d{4}/)[0].replace(/[^\d]/g, '')
    postData = {
      ...postData,
      phoneAreaCode: phoneAreaCode,
      phoneNumber: phoneNumber
    }
  }

  // set child attributes, plus the parentId
  if (data.children && data.children.length > 0) {
    postData.childrenAttributes = data.children.map(function (childAttrs) {
      return {
        ...childAttrs,
        parentId: userId
      }
    })
  }

  if (data.availability) {
    postData = {
      ...postData,
      ...availability
    }
  }

  if (data.employer) {
    postData.employer = data.employer
  }

  if (data.jobPosition) {
    postData.jobPosition = data.jobPosition
  }

  if (data.profileBlurb) {
    postData.profileBlurb = data.profileBlurb
  }

  if (images) {
    postData.images = data.images
  }

  if (data.activities) {
    postData.activities = data.activities
  }

  if (data.languages) {
    postData.languages = data.languages
  }
  if (data.hasPet) {
    postData.hasPet = data.hasPet
  }
  if (data.houseRules) {
    postData.houseRules = data.houseRules
  }
  if (data.petDescription) {
    postData.petDescription = data.petDescription
  }

  return axios.post(
    `/users/${userId}`,
    postData
  ).then(res => {
    logger.log('SUBMIT USER SUCCESS', res)
    return res
  }).catch(err => {
    logger.logError('SUBMIT USER FAILURE', err)
    throw err
  })
}

export async function fetchUser (userId) {
  try {
    const res = await axios.get(`/api/users/${userId}`)
    logger.log('FETCH PUBLIC USER #' + userId + ' SUCCESS')
    return createUser(normalize(res.data))
  } catch (err) {
    logger.logError('FETCH PUBLIC USER #' + userId + ' FAILURE')
    logger.logError(err.errors)
    throw err
  }
}

// Private
export async function fetchCurrentUser (userId) {
  try {
    const res = await axios.get(`/api/users/${userId}`)
    logger.log('FETCH PRIVATE USER #' + userId + ' SUCCESS')
    logger.log(res)
    return createUser(normalize(res.data))
  } catch (err) {
    logger.logError('FETCH PRIVATE USER #' + userId + ' FAILURE')
    logger.logError(err.errors)
    throw err
  }
}

// backend requires user to be an admin
export function fetchAllUsers () {
  return axios.get(
    `/users`
  ).then(res => {
    logger.log('FETCH ALL USERS SUCCESS')
    return createUsers(normalize(res.data))
  }).catch(err => {
    logger.logError('FETCH ALL USERS FAILURE')
    logger.logError(err.errors)
    throw err
  })
}
