import ahoy from 'ahoy.js'

export function trackEvent (name, properties) {
  ahoy.track(name, properties)
}
