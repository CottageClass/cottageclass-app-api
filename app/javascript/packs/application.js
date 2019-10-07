import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import VeeValidate from 'vee-validate'
import VueClipboard from 'vue-clipboard2'
import VueScrollTo from 'vue-scrollto'
import Vuetify from 'vuetify'
import { TimePicker } from 'ant-design-vue'

import '@babel/polyfill'

import App from '@/App.vue'
import router from '@/router'
import store from '@/store'
import { trackEvent } from '@/utils/ahoy'
import { requestPermission } from '@/utils/notifications/push'
import { registerServiceWorker } from '@/utils/registerServiceWorker'
import VueAnalytics from 'vue-analytics'
import GoogleMapsLoader from 'google-maps'

import { logger } from '@/mixins'

import TurbolinksAdapter from 'vue-turbolinks'

import 'ant-design-vue/lib/time-picker/style/css'
import 'vuetify/dist/vuetify.min.css' // Ensure you are using css-loader
// import 'ant-design-vue/dist/antd.css'
import 'vue-image-lightbox/dist/vue-image-lightbox.min.css'

import '../../../src/assets/css/webflow.css'
import '../../../src/assets/css/normalize.css'

import VueLazyLoad from 'vue-lazyload'
import { registerIOSEventLIstener } from '@/utils/iosAdapter.js'
import * as firebase from 'firebase/app'
const firebaseConfig = {
  apiKey: 'AIzaSyC6OILnj9bH_fEbTAI8u1ll9rxZ2wKk1pk',
  authDomain: 'cottageclass-166118.firebaseapp.com',
  databaseURL: 'https://cottageclass-166118.firebaseio.com',
  projectId: 'cottageclass-166118',
  storageBucket: '',
  messagingSenderId: '438514874280',
  appId: '1:438514874280:web:6b1458ceb579d3e4330f9d'
}

// Initialize Firebase
firebase.initializeApp(firebaseConfig)

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
  Vue.use(TimePicker)
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
      next({ name: 'Events' })
    } else {
      next()
    }
  })

  Vue.use(VueAnalytics, {
    id: process.env.GOOGLE_ANALYTICS_ID,
    router
  })
  document.addEventListener('turbolinks:load', () => {
    registerIOSEventLIstener()
    registerServiceWorker()

    const selector = '#app'
    const element = document.querySelector(selector)
    const token = (element && element.dataset && element.dataset.token) || undefined

    if (token) {
      requestPermission()
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
