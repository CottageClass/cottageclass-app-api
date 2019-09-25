<template>
  <Question
    title="Where is your playdate?"
    subtitle="You can host a playdate at your home or invite other parents to meet you at a public place, like a playground or a restaurant.">
    <RadioButtons
      v-model="homeOrPublic"
      :choices="choices"
      :labels="labels" />
    <div
      class="w-form"
      v-if="homeOrPublic == 'public'">
      <p class="describe-label">Where will it be?</p>
      <vue-google-autocomplete
        v-if="googleMapsIsLoaded"
        id="map"
        types=""
        classname="w-input location-text-field"
        placeholder="Enter an address or place."
        v-on:placechanged="getAddressData"
      >
      </vue-google-autocomplete>
    </div>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import GoogleMapsLoader from 'google-maps'
import VueGoogleAutocomplete from 'vue-google-autocomplete'
import RadioButtons from '@/components/base/RadioButtons.vue'

export default {
  name: 'EventPlace',
  components: { Question, VueGoogleAutocomplete, RadioButtons },
  props: ['value', 'context'],
  data () {
    return {
      choices: ['home', 'public'],
      labels: [['home', 'At my home'], ['public', 'In a public place']],
      homeOrPublic: 'home',
      placeId: null,
      defaultSubtitle: "Describe a playdate you'd like to host in your home or public space. It can be a one-time event (like a trip to the zoo) or something you can offer on a regular basis, like arts & crafts, indoor play, or a playground hangout!",
      googleMapsIsLoaded: false
    }
  },
  mounted: function () {
    const that = this
    GoogleMapsLoader.load(function () {
      that.googleMapsIsLoaded = true
    })
  },
  methods: {
    getAddressData: function (addressData, placeResultData, id) {
      this.placeId = placeResultData.place_id
      this.emitPlaceId()
    },
    emitPlaceId: function () {
      this.$emit('input', { err: null, id: this.placeId })
    }
  },
  watch: {
    homeOrPublic: function () {
      this.$emit('input', { err: this.errorMessage, id: null })
    }
  },
  computed: {
    errorMessage () {
      if (this.homeOrPublic === 'public' && this.placeId === null) {
        return 'Please enter an address or place for your playdate.'
      } else if (this.homeOrPublic === null) {
        return 'Please tell us where your playdate will be.'
      } else {
        return null
      }
    }
  },
  created () {
    this.$emit('input', { err: this.errorMessage, id: null })
  }
}
</script>
