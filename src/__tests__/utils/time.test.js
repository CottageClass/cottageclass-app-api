import { localWeekHourToMoment, momentToLocalWeekHour } from '@/utils/time'

import moment from 'moment-timezone'
const losAngelesTimeZone = 'America/Los_Angeles'

describe('let us go to sunny LA', () => {
  afterAll(() => {
    moment.tz.setDefault()
  })
  beforeAll(() => {
    moment.tz.setDefault(losAngelesTimeZone)
  })

  describe('localWeekHourToMoment', () => {
    describe.each([
      [39, moment.tz('2019-05-20T15:00', losAngelesTimeZone)],
      [32, moment.tz('2019-05-27T08:00', losAngelesTimeZone)],
      [0, moment.tz('2019-05-26T00:00', losAngelesTimeZone)],
      [100, moment.tz('2019-05-23T04:00', losAngelesTimeZone)]
    ])('hour %i', (weekHour, expected) => {
      it(`works on weekhour ${weekHour}`, () => {
        const rootTime = moment('2019-05-20T13:37') // 1:37 pm LA time on a monday
        const m = localWeekHourToMoment(weekHour, rootTime, losAngelesTimeZone).format()
        expect(m).toEqual(expected.format())
      })
    })
  })

  describe('momentToLocalWeekHour', () => {
    describe.each([
      [moment('2019-05-20T15:00'), 39],
      [moment('2019-05-27T08:00'), 32],
      [moment('2019-05-26T00:00'), 0],
      [moment('2019-05-23T04:00'), 100]
    ])('moment %p', (actualTime, expected) => {
      it(`works on time :  ${actualTime}`, () => {
        const weekHour = momentToLocalWeekHour(actualTime, losAngelesTimeZone)
        expect(weekHour).toEqual(expected)
      })
    })
  })
})
