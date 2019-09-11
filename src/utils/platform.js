export function isIOSNativeApp () {
  return navigator && navigator.userAgent && navigator.userAgent.includes('LilyPadIOSNative')
}
