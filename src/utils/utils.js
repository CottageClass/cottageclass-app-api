// var moment = require('moment')

export function distanceHaversine (lat1, lon1, lat2, lon2) {
  const unit = 'N' // always return miles
  var radlat1 = Math.PI * lat1 / 180
  var radlat2 = Math.PI * lat2 / 180
  // var radlon1 = Math.PI * lon1 / 180
  // var radlon2 = Math.PI * lon2 / 180
  var theta = lon1 - lon2
  var radtheta = Math.PI * theta / 180
  var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta)
  dist = Math.acos(dist)
  dist = dist * 180 / Math.PI
  dist = dist * 60 * 1.1515
  if (unit === 'K') { dist = dist * 1.609344 }
  if (unit === 'N') { dist = dist * 0.8684 }
  return dist.toFixed(1)
}

export function capitalize (string) {
  return string.charAt(0).toUpperCase() + string.slice(1)
}

export function arrayToSentence (arr) {
  if (arr.length > 1) {
    var last = arr.pop()
    return arr.join(', ') + ' and ' + last
  } else {
    return arr[0]
  }
}

export function childAgeText ({ childAges, singular, plural, prefix, verbose, expectingPrefix = '' }) {
  const childAgesSorted = childAges.concat().sort((a, b) => a - b)
  const ages = childAgesSorted.filter(e => e >= 0)
  const n = ages.length
  if (verbose) {
    switch (n) {
      case 0:
        if (expectingPrefix) {
          return expectingPrefix + 'expecting'
        } else {
          return 'Expecting'
        }
      case 1:
        return prefix + '1 ' + singular + '–age ' + ages[0]
      default: // 2 or more
        return `${prefix}${n} ${plural}–ages ${ages.slice(0, n - 1).join(', ')} and ${ages[n - 1]}`
    }
  } else {
    if (n === 0) {
      if (expectingPrefix) {
        return expectingPrefix + 'expecting'
      } else {
        return 'Expecting'
      }
    } else {
      return n + ' ' + (ages.length > 1 ? plural : singular) + ' (' + ages.join(', ') + ')'
    }
  }
}

export function childAgeSentenceText ({ childAges }) {
  const childAgesSorted = childAges.concat().sort((a, b) => a - b)
  const ages = childAgesSorted.filter(e => e >= 0)
  const n = ages.length
  switch (n) {
    case 0:
      return 'one on the way'
    case 1:
      return '1 kid age ' + ages[0]
    default: // 2 or more
      return `${n} kids age ${ages.slice(0, n - 1).join(', ')} & ${ages[n - 1]}`
  }
}
