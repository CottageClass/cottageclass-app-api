import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import VeeValidate from 'vee-validate'
import VueClipboard from 'vue-clipboard2'
import VueScrollTo from 'vue-scrollto'

import '@babel/polyfill'

import _ from 'lodash'

import App from '@/App.vue'
import router from '@/router'
import store from '@/store'
import '@/registerServiceWorker'
import VueAnalytics from 'vue-analytics'
import GoogleMapsLoader from 'google-maps'

GoogleMapsLoader.KEY = process.env.GOOGLE_API_KEY
GoogleMapsLoader.LIBRARIES = ['geometry', 'places']
GoogleMapsLoader.load()

let isAuthWindow = false
try {
  isAuthWindow = window.opener.location.origin === window.location.origin &&
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
      el: element,
      store,
      router,
      render: h => h(App)
    })
  })
}
