/* eslint no-console: 0 */

import Vue from "vue";

/*
 * Cookie setup
 */
import VueCookies from "vue-cookies";
Vue.use(VueCookies);
/*
 *  VueAxios Setup
 *  - access axios via Vue.axios, this.axios, or this.$http
 */
import axios from "axios";
import VueAxios from "vue-axios";
Vue.use(VueAxios, axios);

// Form validation
import VeeValidate from "vee-validate";
Vue.use(VeeValidate);

/*
 * Copy to clipboard
 */
import VueClipboard from "vue-clipboard2";
Vue.use(VueClipboard);

/*
 * Scrolling to anchor links
 */
var VueScrollTo = require("vue-scrollto");
Vue.use(VueScrollTo);

const origin = window.location.origin;

Vue.config.productionTip = false;

/*
 *  Maps config
 */
import * as VueGoogleMaps from "vue2-google-maps";
Vue.use(VueGoogleMaps, {
  load: {
    key: "AIzaSyCAxZ4ERhmcq87C5HK91ujxDLl7gQ_k_-c"
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
});

router.beforeEach((to, from, next) => {
  store.dispatch("newRoute", { to, from, next });
});

// passing the router into the analytics plugin will automaticall track page views
// TODO figure out dotenv here for google analytics
// import VueAnalytics from "vue-analytics";
// Vue.use(VueAnalytics, {
//   id: process.env.GOOGLE_ANALYTICS_ID,
//   router
// });

import _ from "lodash";

// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import App from "../../../src/App.vue";
import router from "../../../src/router";
import store from "../../../src/store";
import "../../../src/registerServiceWorker";


// this is meant to be called when returning from authentication because the vue app reloads at that point
document.addEventListener("DOMContentLoaded", () => {
  // TODO also store JWT token after a login because this will not be run at that point
  const element = "#app";
  let token = _.get(document.querySelector(element), "dataset.token");
  store.dispatch('establishUser', {JWT: token})

  const csrfElement = "meta[name='csrf-token']"
  let csrfToken = _.get(document.querySelector(csrfElement), "content");


  axios.interceptors.request.use(
    config => {
      config.headers["Authorization"] = `Bearer ${store.getters.JWT}`;
      if (config.method !== 'get') {
        // this is for making api calls to our server.  may not be a valid long term solution
        config.headers['X-CSRF-Token'] = csrfToken
      }
      return config;
    },
    error => {
      return Promise.reject(error);
    }
  );


  new Vue({
    el: element,
    store,
    router,
    render: h => h(App)
  });
});
