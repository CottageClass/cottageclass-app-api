import { localWeekHourToMoment, momentToLocalWeekHour } from '@/utils/time'

import moment from 'moment-timezone'
const losAngelesTimeZone = 'America/Los_Angeles'

describe('localWeekHourToMoment', () => {
  afterAll(() => {
    moment.tz.setDefault()
  })
  beforeAll(() => {
    moment.tz.setDefault(losAngelesTimeZone)
  })
  describe.each([
    [39, '2019-05-20T15:00'],
    [32, '2019-05-27T08:00'],
    [0, '2019-05-26T00:00'],
    [100, '2019-05-23T04:00']
  ])('hour %i', (weekHour, expected) => {
    it(`works on weekhour ${weekHour}`, () => {
      const rootTime = moment('2019-05-20T13:37') // 1:37 pm LA time on a monday
      const m = localWeekHourToMoment(weekHour, rootTime, losAngelesTimeZone).format()
      expect(m).toEqual(moment(expected).format())
    })
  })
})
