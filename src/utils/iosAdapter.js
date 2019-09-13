import { isIOSNativeApp } from '@/utils/platform'

export function registerIOSEventLIstener () {
  if (isIOSNativeApp()) {
    window.addEventListener('lilyPadIOSNativeEvent', function (e) {
      console.log(this)
      console.log(e)
    })
  }
}

export function postMessage (data) {
  if (isIOSNativeApp()) {
    window.webkit.messageHandlers.lilyPad.postMessage(data)
  }
}
