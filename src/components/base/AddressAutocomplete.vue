<template>
  <div class="location-wrapper">
    <div class="location-heading-2">Find parents and playdates near you.</div>
    <div class="formblock-location">
      <div class="form-location">
        <vue-google-autocomplete
          v-if="googleMapsIsLoaded"
          ref="address"
          id="map field-4"
          classname="form-location-input input-field"
          :country="['us']"
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
      this.$emit('locationSubmitted')
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

<style scoped lang="scss">
.input-field {
  height: 44px;
  margin-bottom: 12px;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, .15);
  border-radius: 4px;
  background-color: transparent;
  background-image: linear-gradient(180deg, #fff, #fff);
  font-size: 16px;
}

.formblock-location {
  width: 100%;
  margin-bottom: 0px;
}

.form-location {
  position: relative;
  display: flex;
  width: 100%;
  flex-direction: row;
  justify-content: flex-start;
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
  border-color: #fd6f77;
  border-radius: 4px;
  background-color: hsla(189.35064935064935, 92.77%, 83.73%, 0.10);
  background-image: url("https://assets.website-files.com/5c6c7d4a75c1e54694ed12d1/5cb74731476af65c8b56d2ff_search-black-20.svg"), linear-gradient(180deg, #fff, #fff);
  background-position: 12px 50%, 0px 0px;
  background-size: 24px 24px, auto;
  background-repeat: no-repeat, repeat;
  box-shadow: 0 0 20px 0 rgba(0, 0, 0, .06);
  opacity: 1;
  transform: scale3d(1none, 1none, 1none);
  font-size: 18px;
  font-weight: 400;
  transform-style: preserve-3d;
}

.location-wrapper {
  display: -ms-flexbox;
  display: flex;
  width: 60%;
  padding: 34px 40px 40px;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border-radius: 8px;
  background-color: #fd6f77;
  box-shadow: none;
}

.location-heading {
  margin-bottom: 32px;
  font-size: 20px;
  line-height: 24px;
  font-weight: 700;
  text-align: center;
}

.location-heading-2 {
  margin-bottom: 24px;
  color: #fff;
  -webkit-text-fill-color: #fff;  // DO NOT REMOVE.  REQUIRED FOR SAFARI
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

  .location-heading-2 {
    text-align: center;
  }
}

@media (max-width: 767px) {
  .heading-2 {
    font-size: 20px;
    line-height: 26px;
  }

  .form-location {
    flex-direction: column;
    justify-content: flex-start;
    align-items: flex-start;
    align-content: flex-start;
  }

  .form-location-input {
    height: 50px;
    padding-left: 36px;
    background-image: url("https://assets.website-files.com/5c6c7d4a75c1e54694ed12d1/5cb74731476af65c8b56d2ff_search-black-20.svg"), linear-gradient(180deg, #fff, #fff);
    background-position: 8px 50%, 0px 0px;
    font-size: 16px;
  }

  .location-wrapper {
    width: 100%;
  }
}

@media (max-width: 479px) {
  .heading-2 {
    text-align: center;
  }

  .form-location {
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
