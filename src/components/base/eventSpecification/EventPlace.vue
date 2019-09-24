<template>
  <Question
    title="Where is your playdate?"
    subtitle="You can host a playdate at your home or invite other parents to meet you at a public place, like a playground or a restaurant.">
    <div class="w-form">
      <vue-google-autocomplete
        v-if="googleMapsIsLoaded"
        id="map"
        types=""
        classname="w-input location-text-field"
        placeholder="e.g. 10 Main St. or Elm Library"
        v-on:placechanged="getAddressData"
      >
      </vue-google-autocomplete>
    </div>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'
import GoogleMapsLoader from 'google-maps'
import VueGoogleAutocomplete from 'vue-google-autocomplete'

export default {
  name: 'EventPlace',
  components: { Question, FormWithTextArea, VueGoogleAutocomplete },
  props: ['value', 'context'],
  data () {
    return {
      place: this.value.text,
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
      console.log(addressData, placeResultData, id)
    }
  },
  computed: {
    errorMessage () {
      return (this.place && this.place.length >= 1) ? null : 'Please tell us where your playdate will be'
    }
  },
  created () {
    this.$emit('input', { err: this.errorMessage, text: this.place })
  },
  watch: {
    description: function () {
      this.$emit('input', { err: this.errorMessage, text: this.place })
    }
  }
}
</script>
