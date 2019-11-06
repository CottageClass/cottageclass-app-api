import { isIOSNativeApp } from '@/utils/platform'
import { createDevice } from '@/utils/api'

export function registerIOSEventLIstener () {
  if (isIOSNativeApp()) {
    window.addEventListener('lilyPadIOSNativeEvent', function (e) {
      console.log(e)
      if (e.detail.name === 'deviceTokenReceived') {
        createDevice({ token: e.detail.token, platform: 'ios' })
      }
    })
  }
}

export function postMessage (data) {
  if (isIOSNativeApp()) {
    window.webkit.messageHandlers.lilyPad.postMessage(data)
  }
}
