<template>
  <div class="wrapper">
    <img src="@/assets/baseline-search-24px.svg" alt="" class="search-icon">
    <vue-google-autocomplete
          v-if="googleMapsIsLoaded"
          ref="address"
          id="map"
          classname="address-field"
          :placeholder="placeholder"
          v-on:placechanged="getAddressData"
          country="us" />
    <input type="submit"
           class="submitButton"
           :class="{ active: latlng }"
           value="Find Parents & Playdates"
           @click="submitAddress">
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
    submitAddress () {
      if (this.latlng) {
        this.$store.commit('setMapArea', { center: this.latlng })
        this.$router.push({ name: 'Events' })
      }
    },
    getAddressData (e) {
      this.latlng = { lat: e.latitude, lng: e.longitude }
    }
  },
  mounted: function () {
    const that = this
    GoogleMapsLoader.load(function () {
      that.googleMapsIsLoaded = true
    })
  },
  computed: {
    placeholder () { return 'What\'s your address?' }
  }
}
</script>

<style lang="scss">

.wrapper {
  position: relative;
  display: flex;
  width: 80%;
  flex-direction: row;
  justify-content: flex-start;
  align-items: flex-start;
  border-radius: 4px;
  box-shadow: 0 0 30px 0 hsla(208.8118811881188, 0.00%, 0.00%, 0.20);
}
.submitButton {
  &:focus {
    outline-offset: -2px;
    outline: -webkit-focus-ring-color auto 2px;
    outline-color: -webkit-focus-ring-color;
    outline-style: auto;
    outline-width: 2px;
  }
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, .15);
  border-radius: 0px 4px 4px 0px;
  box-shadow: none;
  color: hsla(208.8118811881188, 0.00%, 100.00%, 1.00);
  display: inline-block;
  padding: 9px 15px;
  background-color: hsla(208.8118811881188, 82.11%, 51.76%, 0.5);
  border: 0;
  line-height: inherit;
  text-decoration: none;
  white-space:nowrap;
  height: 50px;
}

.submitButton.active{
  &:hover {
    background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
    background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
    text-decoration: none;
  }
  background-color: hsla(208.8118811881188, 82.11%, 51.76%, 1.00);
    cursor: pointer;

}
.address-field {
  &:focus {
    outline-offset: -2px;
    outline: -webkit-focus-ring-color auto 2px;
    outline-color: -webkit-focus-ring-color;
    outline-style: auto;
    outline-width: 2px;
  }
  width: 100%;
  height: 50px;
  margin-bottom: 0px;
  padding-top: 1px;
  padding-left: 40px;
  border-style: solid;
  border-width: 1px;
  border-color: #cfcfcf;
  border-radius: 4px 0px 0px 4px;
  background-color: rgba(0, 0, 0, .03);
  background-image: none;
  font-size: 16px;
  font-weight: 400;
}
.search-icon {
  position: absolute;
  left: 10px;
  top: 14px;
  right: auto;
  bottom: 0%;
  opacity: 0.3;
}

@media (max-width: 479px) {
  .wrapper {
    flex-direction: column;
    width:100%;
  }
  .submitButton {
    border-radius: 0px 0px 4px 4px;
    width:100%;
  }
  .address-field {
    border-radius: 4px 4px 0px 0px;
  }
}

</style>
