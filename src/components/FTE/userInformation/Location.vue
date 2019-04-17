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
    getAddressData: function (addressData, placeResultData, id) {
      let placeResultObject = {}
      placeResultData.address_components.forEach(e =>
        e.types.forEach(type => (placeResultObject[type] = e.long_name))
      )
      this.address = { ...addressData, ...placeResultObject }
      this.emitAddress()
    },
    emitAddress: function () {
      console.log('emitting address')
      if (this.address.latitude) {
        this.$emit('input', {
          fullAddress: this.address,
          lat: this.address.latitude,
          lng: this.address.longitude,
          apartmentNumber: this.apartmentNumber,
          err: this.err
        })
      } else if (this.apartmentNumber) {
        this.$emit('input', {
          apartmentNumber: this.apartmentNumber,
          err: this.err
        })
      } else {
        this.$emit('input', {
          err: this.err
        })
      }
    }
  },
  computed: {
    err: function () {
      if (this.required && (isNaN(this.address.latitude) || isNaN(this.address.longitude))) {
        return 'There was a problem processing your street address. Try again?'
      } else {
        return false
      }
    }
  },
  watch: {
    apartmentNumber: function () {
      this.emitAddress()
    },
    err: function () {
      this.emitAddress()
    }
  }
}
</script>
