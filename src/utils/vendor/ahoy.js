import ahoy from 'ahoy.js'

export function trackEvent ({ name, properties }) {
  console.log('hji')
  ahoy.track(name, properties)
}
