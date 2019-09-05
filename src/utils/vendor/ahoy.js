import ahoy from 'ahoy.js'

export const trackEvent = async (name, properties) => {
  return ahoy.track(name, properties)
}
