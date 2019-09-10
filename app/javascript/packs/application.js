import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import VeeValidate from 'vee-validate'
import VueClipboard from 'vue-clipboard2'
import VueScrollTo from 'vue-scrollto'
import Vuetify from 'vuetify'

import '@babel/polyfill'

import App from '@/App.vue'
import router from '@/router'
import store from '@/store'
import { trackEvent } from '@/utils/ahoy'
import VueAnalytics from 'vue-analytics'
import GoogleMapsLoader from 'google-maps'

import { logger } from '@/mixins'

import TurbolinksAdapter from 'vue-turbolinks'

import 'vuetify/dist/vuetify.min.css' // Ensure you are using css-loader
import 'vue-image-lightbox/dist/vue-image-lightbox.min.css'

import VueLazyLoad from 'vue-lazyload'

var Turbolinks = require('turbolinks')
Turbolinks.start()

GoogleMapsLoader.KEY = process.env.GOOGLE_API_KEY
GoogleMapsLoader.LIBRARIES = ['geometry', 'places']
GoogleMapsLoader.load()

// using this to have better logging in the browser
window.localStorage.debug = process.env.DEBUG

let isAuthWindow = false
try {
  isAuthWindow = window.opener.location.origin === window.location.origin &&
                 window.opener.oauthCallback
} catch (e) {
}

if (isAuthWindow) {
  // If we're in a popup window that was opened for authentication, fire callback and close it
  document.addEventListener('DOMContentLoaded', () => {
    const selector = '#app'
    const element = document.querySelector(selector)
    const token = (element && element.dataset && element.dataset.token) || undefined
    if (window.opener.oauthCallback) {
      window.opener.oauthCallback({ token })
      delete window.opener.oauthCallback
    }
    window.close()
  })
} else {
  // Load all the Vue plugins
  Vue.use(TurbolinksAdapter)
  Vue.use(VueLazyLoad)
  Vue.mixin(logger)
  Vue.use(VueScrollTo)
  Vue.use(VueAxios, axios)
  Vue.use(VeeValidate)
  Vue.use(VueClipboard)
  Vue.use(Vuetify)

  Vue.config.productionTip = false

  router.beforeEach((to, from, next) => {
    store.dispatch('newRoute')
    trackEvent('page_view', { to: to.fullPath, from: from.fullPath })
    if (to.name === 'SplashPage' && store.getters.isAuthenticated) {
      next({ name: 'Search' })
    } else {
      next()
    }
  })

  Vue.use(VueAnalytics, {
    id: process.env.GOOGLE_ANALYTICS_ID,
    router
  })
  document.addEventListener('turbolinks:load', () => {
    const selector = '#app'
    const element = document.querySelector(selector)
    const token = (element && element.dataset && element.dataset.token) || undefined

    if (token) {
      store.dispatch('establishUser', { JWT: token })
    }

    const csrfElement = "meta[name='csrf-token']"
    let csrfToken = document.querySelector(csrfElement).content

    axios.interceptors.request.use(
      config => {
        if (store.getters.JWT) {
          config.headers['Authorization'] = `Bearer ${store.getters.JWT}`
        }
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

    /* eslint-disable no-new */
    new Vue({
      el: selector,
      store,
      router,
      render: h => h(App)
    })
  })
}
