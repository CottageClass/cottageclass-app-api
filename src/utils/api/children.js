import axios from 'axios'

import Logger from '@/utils/logger'
const logger = Logger('api:children')

export function submitEmergencyContacts (childId, arrayOfContacts) {
  return axios.put(
    `/api/user/children/${childId}`,
    {
      child:
      {
        'emergency_contacts_attributes': arrayOfContacts
      }
    }).then(res => {
    logger.log('SUBMIT EMERGENCY CONTACTS SUCCESS', res)
  }).catch(err => {
    logger.logError('SUBMIT EMERGENCY CONTACTS FAILURE', childId, arrayOfContacts)
    throw err
  })
}
