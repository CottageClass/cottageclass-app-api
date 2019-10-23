<template>
  <Question
    title="What's your home address?"
    subtitle="Please enter your address so we can list your playdate & find playdates near you. Only your guests will see this.*"
    explanation="* Members who RSVP to your playdate will see your address. Non-members will see an approximate location within a few blocks.">
    <div class="w-form">
      <vue-google-autocomplete
        v-if="googleMapsIsLoaded"
        id="map"
        classname="w-input location-text-field"
        :placeholder="currentAddress"
        v-on:placechanged="getAddressData"
      >
      </vue-google-autocomplete>
    </div>
    <form id="email-form-2" v-on:submit.prevent>
      <input
        v-if="showApartmentField"
        @keyup.enter="$emit('pressedEnter')"
        name="apartmentNumber"
        v-model="apartmentNumber"
        :placeholder="apartmentNumber || 'Apartment #'"
        class="location-text-field w-input"
      ></form>
    <a v-if="!showApartmentField" @click="toggleApartmentField" class="onb-button-add-group w-inline-block"><img src="@/assets/add.svg" alt="" class="image-7"><div class="onb-button-add-group-text">Add apartment #</div></a>
  </Question>
</template>

<script>
import GoogleMapsLoader from 'google-maps'
import VueGoogleAutocomplete from 'vue-google-autocomplete'
import Question from '@/components/base/Question.vue'

export default {
  name: 'Location',
  props: ['currentAddress', 'value', 'required', 'currentApartment'],
  components: { Question, VueGoogleAutocomplete },
  data () {
    return {
      textEntered: '',
      showApartmentField: !!this.currentApartment,
      apartmentNumber: this.currentApartment || '',
      placeholder: this.currentAddress || 'Street address (not apt #)',
      address: {},
      googlePlaceId: this.value.googleId,
      latlng: null,
      googleMapsIsLoaded: false
    }
  },
  mounted: function () {
    const that = this
    GoogleMapsLoader.load(function () {
      that.googleMapsIsLoaded = true
    })

    if (!this.currentAddress) {
      this.$emit('input', {
        err: 'Please enter your street address.'
      })
    }
  },
  methods: {
    toggleApartmentField: function () {
      this.showApartmentField = true
    },
    async emitPlace () {
      if (this.err) {
        this.$emit('input', {
          err: this.err
        })
      } else {
        if (this.googlePlaceId === null) { return }
        this.$emit('input', { err: null,
          googleId: this.googlePlaceId,
          apartmentNumber: this.apartmentNumber
        })
      }
    },
    getAddressData: function (addressData, placeResultData, id) {
      this.latlng = {
        lat: addressData.latitude,
        lng: addressData.longitude
      }
      this.googlePlaceId = placeResultData.place_id
      this.emitPlace()
    }
  },
  computed: {
    err: function () {
      if (this.required && !this.googlePlaceId) {
        return 'There was a problem processing your street address. Try again?'
      } else {
        return false
      }
    }
  },
  watch: {
    apartmentNumber: function () {
      this.emitPlace()
    },
    err: function () {
      this.emitPlace()
    }
  }
}
</script>
<style lang="scss" scoped>
.flow {
  .onb-button-add-group {
    display: flex;
    margin-bottom: 63px;
    padding: 10px 16px;
    justify-content: center;
    align-items: center;
    border-radius: 4px;
    background-color: hsla(0, 0%, 100%, 0);
  }

  .onb-button-add-group:active {
    border-radius: 4px;
    background-color: hsla(0, 0%, 100%, .1);
  }

  .onb-button-add-group-text {
    padding-left: 8px;
    color: #fff;
    line-height: 14px;
    letter-spacing: 1.2px;
    text-transform: uppercase;
  }
  .image-7 {
    opacity: 0.7;
  }
}
</style>
