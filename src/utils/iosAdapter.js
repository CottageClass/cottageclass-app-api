import { isIOSNativeApp } from '@/utils/platform'
import { createDevice } from '@/utils/api'
import store from '@/store'

export function registerIOSEventLIstener () {
  if (isIOSNativeApp()) {
    window.addEventListener('lilyPadIOSNativeEvent', function (e) {
      if (e.detail.name === 'deviceTokenReceived') {
        createDevice({ token: e.detail.token, platform: 'ios' })
      }
      if (e.detail.name === 'applicationDidEnterForeground') {
        store.dispatch('resetToBaseState')
      }
    })
  }
}

export function postMessage (data) {
  if (isIOSNativeApp()) {
    window.webkit.messageHandlers.lilyPad.postMessage(data)
  }
}
