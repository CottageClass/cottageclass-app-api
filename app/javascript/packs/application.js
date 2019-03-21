import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import VeeValidate from 'vee-validate'
import VueClipboard from 'vue-clipboard2'
import VueScrollTo from 'vue-scrollto'
import * as VueGoogleMaps from 'vue2-google-maps'

import '@babel/polyfill'

import _ from 'lodash'

import App from '../../../src/App.vue'
import router from '../../../src/router'
import store from '../../../src/store'
import '../../../src/registerServiceWorker'
import VueAnalytics from 'vue-analytics'

let isAuthWindow = false
try {
  isAuthWindow = window.opener &&
                 window.opener.location &&
                 window.opener.location.origin === window.location.origin &&
                 window.opener.oauthCallback
} catch (e) {
  console.log(e)
}

if (isAuthWindow) {
  // If we're in a popup window that was opened for authentication, fire callback and close it
  document.addEventListener('DOMContentLoaded', () => {
    const element = '#app'
    let token = _.get(document.querySelector(element), 'dataset.token')
    if (window.opener.oauthCallback) {
      window.opener.oauthCallback({ token })
      _.unset(window, 'opener.oauthCallback')
    }
    window.close()
  })
} else {
  // Load all the Vue plugins
  Vue.use(VueScrollTo)
  Vue.use(VueAxios, axios)
  Vue.use(VeeValidate)
  Vue.use(VueClipboard)
  Vue.use(VueGoogleMaps, {
    load: {
      key: 'AIzaSyCAxZ4ERhmcq87C5HK91ujxDLl7gQ_k_-c'
      // libraries: 'geocoder', // This is required if you use the Autocomplete plugin
      // OR: libraries: 'places,drawing'
      // OR: libraries: 'places,drawing,visualization'
      // (as you require)

      /// / If you want to set the version, you can do so:
      // v: '3.26',
    }

    /// / If you intend to programmatically custom event listener code
    /// / (e.g. `this.$refs.gmap.$on('zoom_changed', someFunc)`)
    /// / instead of going through Vue templates (e.g. `<GmapMap @zoom_changed="someFunc">`)
    /// / you might need to turn this on.
    // autobindAllEvents: false,

    /// / If you want to manually install components, e.g.
    /// / import {GmapMarker} from 'vue2-google-maps/src/components/marker'
    /// / Vue.component('GmapMarker', GmapMarker)
    /// / then disable the following:
    // installComponents: true,
  })

  Vue.config.productionTip = false

  router.beforeEach((to, from, next) => {
    store.dispatch('newRoute')
    if (to.name === 'SplashPage' && store.getters.isAuthenticated) {
      next({ name: 'Events' })
    } else {
      next()
    }
  })

  Vue.use(VueAnalytics, {
    id: process.env.GOOGLE_ANALYTICS_ID,
    router
  })

  document.addEventListener('DOMContentLoaded', () => {
    const element = '#app'
    let token = _.get(document.querySelector(element), 'dataset.token')
    store.dispatch('establishUser', { JWT: token })

    const csrfElement = "meta[name='csrf-token']"
    let csrfToken = _.get(document.querySelector(csrfElement), 'content')

    axios.interceptors.request.use(
      config => {
        config.headers['Authorization'] = `Bearer ${store.getters.JWT}`
        if (config.method !== 'get') {
          // this is for making api calls to our server.  may not be a valid long term solution
          config.headers['X-CSRF-Token'] = csrfToken
        }
        return config
      },
      error => {
        return Promise.reject(error)
      }
    )

    new Vue({
      el: element,
      store,
      router,
      render: h => h(App)
    })
  })
}
