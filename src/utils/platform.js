export function isIOSNativeApp () {
  return navigator && navigator.userAgent && navigator.userAgent.includes('LilyPadIOSNative')
}

export function isPWA () {
  return (window.matchMedia('(display-mode: standalone)').matches)
}

export function isNative () {
  return isIOSNativeApp() || isPWA()
}
