import { createUser } from '../createUser'
import axios from 'axios'
import normalize from 'json-api-normalizer'

import Logger from '@/utils/logger'
const logger = Logger('api:users')

export async function submitUserInfo (userId, data) {
  if (!data) { return }
  let { phone, availability, settingEmailNotifications, settingMaxDistance, firebaseToken } = data
  let postData = {}

  if (phone && phone.number) {
    let phoneAreaCode = phone.number.match(/(\(\d+\))/)[0].replace(/[^\d]/g, '')
    let phoneNumber = phone.number.match(/\d{3}-\d{4}/)[0].replace(/[^\d]/g, '')
    postData = {
      ...postData,
      phoneAreaCode: phoneAreaCode,
      phoneNumber: phoneNumber
    }
  }

  if (data.place) {
    postData.placeAttributes = {
      googleId: data.place.googleId,
      apartmentNumber: data.place.apartmentNumber,
      creatorId: userId,
      public: false
    }
  }

  // set child attributes, plus the parentId
  if (data.children && data.children.length > 0) {
    postData.childrenAttributes = data.children.map(function (childAttrs) {
      return {
        ...childAttrs,
        parentId: userId,
        birthday: childAttrs.birthYear + '-' + childAttrs.birthMonth + '-15'
      }
    })
  }

  if (data.availability) {
    postData = {
      ...postData,
      ...availability
    }
  }
  if (data.firebaseToken) {
    postData = { ...postData, firebaseToken }
  }
  const { employer, jobPosition, profileBlurb, images, activities } = data
  const { avatar, languages, hasPet, houseRules, petDescription } = data
  postData = { ...postData, employer, jobPosition, profileBlurb, images, activities }
  postData = { ...postData, avatar, languages, hasPet, houseRules, petDescription, settingEmailNotifications, settingMaxDistance }

  try {
    const res = await axios.put(`/api/users/${userId}`, postData)
    logger.log('SUBMIT USER SUCCESS', res)
    return res
  } catch (err) {
    logger.logError(err)
    throw err
  }
}

export async function fetchUser (userId) {
  try {
    const res = await axios.get(`/api/users/${userId}`)
    logger.log('FETCH PUBLIC USER #' + userId + ' SUCCESS')
    return createUser(normalize(res.data))
  } catch (err) {
    logger.logError(err)
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
    logger.logError(err)
    throw err
  }
}
