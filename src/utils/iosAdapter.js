import { isIOSNativeApp } from '@/utils/platform'
import { createDevice } from '@/utils/api'
import store from '@/store'

import VueScrollTo from 'vue-scrollto'

export function registerIOSEventLIstener () {
  if (isIOSNativeApp()) {
    window.addEventListener('lilyPadIOSNativeEvent', function (e) {
      if (e.detail.name === 'deviceTokenReceived') {
        createDevice({ token: e.detail.token, platform: 'ios' })
      }
      if (e.detail.name === 'applicationDidEnterForeground') {
        store.dispatch('resetToBaseState')
      }
      if (e.detail.name === 'keyboardHidden') {
        VueScrollTo.scrollTo('body', { duration: 340, easing: 'ease-in' })
      }
    })
  }
}

export function postMessage (data) {
  if (isIOSNativeApp()) {
    window.webkit.messageHandlers.lilyPad.postMessage(data)
  }
}
