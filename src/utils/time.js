import moment from 'moment-timezone'

/**
 * @param {int}         weekHour        The whole hour of the week, in local time. 0 = Shnday morning at 12am .
 * @param {moment}      rootTime        Earliest acceptable moment.
 * @param {string}      timeZone        Timezone injected.  Only for testing.  Defaults to local
 * @return {moment}     Moment that is no more than one week after the root time and has the correct weekHour
 */

export function localWeekHourToMoment (weekHour, rootTime, timeZone) {
  if (timeZone) {
    moment.tz.setDefault(timeZone)
  }

  const [dow, hour] = rootTime.clone().format('E HH').split(' ')
  const rootWeekHour = 24 * parseInt(dow) + parseInt(hour)
  const weekStart = rootTime.clone().startOf('week')
  if (rootWeekHour < weekHour) {
    return weekStart.add({ hours: weekHour })
  } else {
    return weekStart.add({ weeks: 1, hours: weekHour })
  }
}

export function momentToLocalWeekHour (time, timeZone) {
  if (timeZone) {
    moment.tz.setDefault(timeZone)
  }
  const [dow, hour] = time.clone().format('E HH').split(' ')
  return (24 * parseInt(dow) + parseInt(hour)) % (7 * 24)
}
