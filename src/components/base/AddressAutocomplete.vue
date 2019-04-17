<template>
  <div class="location-wrapper">
    <div class="location-heading-2">Find parents and playdates near you!</div>
    <div class="formblock-location">
      <div class="form-location">
    <vue-google-autocomplete
          v-if="googleMapsIsLoaded"
          ref="address"
          id="map field-4"
          classname="form-location-input input-field"
          :placeholder="placeholder"
          v-on:placechanged="submitAddress"
          country="us" />
          </div>
     </div>
  </div>
</template>

<script>
import VueGoogleAutocomplete from 'vue-google-autocomplete'
import GoogleMapsLoader from 'google-maps'

export default {
  name: 'AddressAutocomplete',
  components: { VueGoogleAutocomplete },
  data () {
    return {
      latlng: null,
      googleMapsIsLoaded: false
    }
  },
  methods: {
    submitAddress (e) {
      this.latlng = { lat: e.latitude, lng: e.longitude }
      this.$store.commit('setMapArea', { center: this.latlng })
      this.$router.push({ name: 'Events' })
    }
  },
  mounted: function () {
    const that = this
    GoogleMapsLoader.load(function () {
      that.googleMapsIsLoaded = true
    })
  },
  computed: {
    placeholder () { return 'Enter your address...' }
  }
}
</script>

<style lang="scss">

/* Generated on: Wed Apr 17 2019 16:02:59 GMT+0000 (UTC) */

/* ==========================================================================
   normalize.css v3.0.3 | MIT License | github.com/necolas/normalize.css
   ========================================================================== */

/*! normalize.css v3.0.3 | MIT License | github.com/necolas/normalize.css */

[hidden] {
  display: none;
}

button,input {
  color: inherit;
  font: inherit;
  margin: 0;
}

button {
  overflow: visible;
}

button {
  text-transform: none;
}

button,html input[type="button"],input[type="reset"] {
  -webkit-appearance: button;
  cursor: pointer;
}

button[disabled],html input[disabled] {
  cursor: default;
}

button::-moz-focus-inner,input::-moz-focus-inner {
  border: 0;
  padding: 0;
}

input {
  line-height: normal;
}

input[type="checkbox"],input[type="radio"] {
  box-sizing: border-box;
  padding: 0;
}

input[type="number"]::-webkit-inner-spin-button,input[type="number"]::-webkit-outer-spin-button {
  height: auto;
}

input[type="search"] {
  -webkit-appearance: none;
}

input[type="search"]::-webkit-search-cancel-button,input[type="search"]::-webkit-search-decoration {
  -webkit-appearance: none;
}

/* ==========================================================================
   Start of base Webflow CSS - If you're looking for some ultra-clean CSS, skip the boilerplate and see the unminified code below.
   ========================================================================== */

@font-face {
  font-family: 'webflow-icons';
  src: url("data:application/x-font-ttf;charset=utf-8;base64,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") format('truetype');
  font-weight: normal;
  font-style: normal;
}

[class^="w-icon-"],[class*=" w-icon-"] {
  font-family: 'webflow-icons' !important;
  speak: none;
  font-style: normal;
  font-weight: normal;
  font-variant: normal;
  text-transform: none;
  line-height: 1;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

* {
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

html {
  height: 100%;
}

body {
  margin: 0;
  min-height: 100%;
  background-color: #fff;
  font-family: Arial,sans-serif;
  font-size: 14px;
  line-height: 20px;
  color: #333;
}

.w-button {
  display: inline-block;
  padding: 9px 15px;
  background-color: #3898EC;
  color: white;
  border: 0;
  line-height: inherit;
  text-decoration: none;
  cursor: pointer;
  border-radius: 0;
}

input.w-button {
  -webkit-appearance: button;
}

html[data-w-dynpage] [data-w-cloak] {
  color: transparent !important;
}

button,html input[type="button"],input[type="reset"] {
  border: 0;
  cursor: pointer;
  -webkit-appearance: button;
}

.w-form {
  margin: 0 0 15px;
}

.input-field::placeholder {
  color: #999;
}

.w-input[disabled],.w-input[readonly] {
  cursor: not-allowed;
  background-color: #eeeeee;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }

  100% {
    transform: rotate(360deg);
  }
}

/* ==========================================================================
   Start of custom Webflow CSS
   ========================================================================== */

body {
  font-family: soleil, sans-serif;
  color: #333;
  font-size: 14px;
  line-height: 20px;
}

.body {
  overflow: visible;
  background-color: #fff;
  font-family: soleil, sans-serif;
}

.body-2 {
  background-color: #f6f6f6;
}

.heading-2 {
  margin-top: 0px;
  font-size: 24px;
}

.input-field {
  height: 44px;
  margin-bottom: 12px;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, .15);
  border-radius: 4px;
  background-color: transparent;
  background-image: -webkit-gradient(linear, left top, left bottom, from(#fff), to(#fff));
  background-image: linear-gradient(180deg, #fff, #fff);
  font-size: 16px;
}

.formblock-location {
  width: 100%;
  margin-bottom: 0px;
}

.form-location {
  position: relative;
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 100%;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  -webkit-flex-direction: row;
  -ms-flex-direction: row;
  flex-direction: row;
  -webkit-box-pack: start;
  -webkit-justify-content: flex-start;
  -ms-flex-pack: start;
  justify-content: flex-start;
  -webkit-box-align: start;
  -webkit-align-items: flex-start;
  -ms-flex-align: start;
  align-items: flex-start;
  border-radius: 4px;
}

.form-location-input {
  width: 100%;
  height: 64px;
  margin-bottom: 0px;
  padding-left: 44px;
  border-style: solid;
  border-width: 1px;
  border-color: hsla(208.65671641791045, 81.38%, 51.57%, 1.00);
  border-radius: 4px;
  background-color: hsla(189.35064935064935, 92.77%, 83.73%, 0.10);
  background-image: url("https://assets.website-files.com/5c6c7d4a75c1e54694ed12d1/5cb74731476af65c8b56d2ff_search-black-20.svg"), -webkit-gradient(linear, left top, left bottom, from(#fff), to(#fff));
  background-image: url("https://assets.website-files.com/5c6c7d4a75c1e54694ed12d1/5cb74731476af65c8b56d2ff_search-black-20.svg"), linear-gradient(180deg, #fff, #fff);
  background-position: 12px 50%, 0px 0px;
  background-size: 24px 24px, auto;
  background-repeat: no-repeat, repeat;
  box-shadow: 0 0 20px 0 rgba(0, 0, 0, .06);
  opacity: 1;
  -webkit-transform: scale3d(1none, 1none, 1none);
  transform: scale3d(1none, 1none, 1none);
  font-size: 18px;
  font-weight: 400;
  -webkit-transform-style: preserve-3d;
  transform-style: preserve-3d;
}

.btn-location-submit {
  position: absolute;
  left: auto;
  top: 0%;
  right: 0%;
  bottom: 0%;
  display: none;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, .15);
  border-radius: 0px 4px 4px 0px;
  background-color: hsla(208.8118811881188, 82.11%, 51.76%, 1.00);
  box-shadow: none;
  color: hsla(208.8118811881188, 0.00%, 100.00%, 1.00);
}

.btn-location-submit:hover {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
  text-decoration: none;
}

.location-wrapper {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 60%;
  padding: 34px 40px 40px;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -webkit-flex-direction: column;
  -ms-flex-direction: column;
  flex-direction: column;
  -webkit-box-pack: center;
  -webkit-justify-content: center;
  -ms-flex-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
  border-radius: 8px;
  background-color: hsla(208.8118811881188, 82.11%, 51.76%, 1.00);
  box-shadow: none;
}

.location-heading {
  margin-bottom: 32px;
  font-size: 20px;
  line-height: 24px;
  font-weight: 700;
  text-align: center;
}

.location-wrapper-2 {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 60%;
  padding: 32px 32px 36px;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -webkit-flex-direction: column;
  -ms-flex-direction: column;
  flex-direction: column;
  -webkit-box-pack: center;
  -webkit-justify-content: center;
  -ms-flex-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
  border-radius: 8px;
  background-color: hsla(208.8118811881188, 82.11%, 51.76%, 1.00);
}

.location-heading-2 {
  margin-bottom: 24px;
  color: #fff;
  font-size: 20px;
  line-height: 24px;
  font-weight: 700;
  text-align: center;
}

@media (max-width: 991px) {
  .formblock-location {
    width: 100%;
  }

  .location-wrapper {
    width: 80%;
  }

  .location-heading {
    text-align: center;
  }

  .location-wrapper-2 {
    width: 80%;
  }

  .location-heading-2 {
    text-align: center;
  }
}

@media (max-width: 767px) {
  .body {
    padding-bottom: 100px;
  }

  .heading-2 {
    font-size: 20px;
    line-height: 26px;
  }

  .form-location {
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    -webkit-flex-direction: column;
    -ms-flex-direction: column;
    flex-direction: column;
    -webkit-box-pack: start;
    -webkit-justify-content: flex-start;
    -ms-flex-pack: start;
    justify-content: flex-start;
    -webkit-box-align: start;
    -webkit-align-items: flex-start;
    -ms-flex-align: start;
    align-items: flex-start;
    -webkit-align-content: flex-start;
    -ms-flex-line-pack: start;
    align-content: flex-start;
  }

  .form-location-input {
    height: 50px;
    padding-left: 36px;
    background-image: url("https://assets.website-files.com/5c6c7d4a75c1e54694ed12d1/5cb74731476af65c8b56d2ff_search-black-20.svg"), -webkit-gradient(linear, left top, left bottom, from(#fff), to(#fff));
    background-image: url("https://assets.website-files.com/5c6c7d4a75c1e54694ed12d1/5cb74731476af65c8b56d2ff_search-black-20.svg"), linear-gradient(180deg, #fff, #fff);
    background-position: 8px 50%, 0px 0px;
    font-size: 16px;
  }

  .location-wrapper {
    width: 100%;
  }

  .location-wrapper-2 {
    width: 100%;
  }
}

@media (max-width: 479px) {
  .body {
    padding-bottom: 110px;
  }

  .heading-2 {
    text-align: center;
  }

  .form-location {
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    -webkit-flex-direction: column;
    -ms-flex-direction: column;
    flex-direction: column;
  }

  .location-wrapper {
    margin-bottom: 40px;
    padding: 20px 16px;
    box-shadow: none;
  }

  .location-heading {
    margin-bottom: 20px;
  }
}

</style>
