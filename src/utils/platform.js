export function isIOSNativeApp () {
  return navigator && navigator.userAgent && navigator.userAgent.includes('LilyPadIOSNative')
}

export function isPWA () {
  return (window.matchMedia('(display-mode: standalone)').matches)
}

export function isNative () {
  return isIOSNativeApp() || isPWA()
}

export function isIPhoneX () {
  // somewhat hacky but effective way to detect if it's an iPhone X (and therefore if it has a notch)
  var iOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream
  var ratio = window.devicePixelRatio || 1
  var screen = {
    width: window.screen.width * ratio,
    height: window.screen.height * ratio
  }
  return (iOS && screen.width === 1125 && screen.height === 2436)
}
