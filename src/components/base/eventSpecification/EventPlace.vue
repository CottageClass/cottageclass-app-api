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
      v-if="isPublic">
      <p class="describe-label">Where will it be?</p>
      <vue-google-autocomplete
        v-if="googleMapsIsLoaded"
        id="map"
        types=""
        classname="w-input location-text-field"
        :placeholder=addressPlaceholder
        v-on:placechanged="getAddressData"
      >
      </vue-google-autocomplete>
    </div>
  </Question>
</template>

<script>
import { mapGetters } from 'vuex'
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
      homeOrPublic: this.value.public ? 'public' : 'home',
      googlePlaceId: this.value.googleId,
      formattedAddress: this.value.formattedAddress,
      defaultSubtitle: "Describe a playdate you'd like to host in your home or public space. It can be a one-time event (like a trip to the zoo) or something you can offer on a regular basis, like arts & crafts, indoor play, or a playground hangout!",
      googleMapsIsLoaded: false
    }
  },
  mounted: function () {
    const that = this
    GoogleMapsLoader.load(function () {
      that.googleMapsIsLoaded = true
    })
    this.emitPlaceId()
  },
  methods: {
    getAddressData: function (addressData, placeResultData, id) {
      this.googlePlaceId = placeResultData.place_id
      this.formattedAddress = placeResultData.formatted_address

      this.emitPlaceId()
    },
    emitPlaceId: function () {
      const err = this.errorMessage
      const payload = this.isPublic ? {
        err,
        googleId: this.googlePlaceId,
        public: this.isPublic,
        creatorId: this.currentUser.id,
        formattedAddress: this.isPublic ? this.formattedAddress : null
      } : this.currentUser.place
      this.$emit('input', payload)
    }
  },
  watch: {
    homeOrPublic: function () {
      this.emitPlaceId()
    }
  },
  computed: {
    addressPlaceholder () {
      if (this.isPublic) {
        return this.value.formattedAddress || 'Enter an address or place.'
      } else {
        return 'Enter an address or place.'
      }
    },
    isPublic () {
      return this.homeOrPublic === 'public'
    },
    errorMessage () {
      if (this.homeOrPublic === 'public' && !this.googlePlaceId) {
        return 'Please enter an address or place for your playdate.'
      } else if (this.homeOrPublic === null) {
        return 'Please tell us where your playdate will be.'
      } else {
        return null
      }
    },
    ...mapGetters(['currentUser'])
  }
}
</script>

<style lang="scss" scoped src="@/assets/style/scss/flow.scss"></style>
<style lang="scss" scoped>
  .location-text-field {
    height: 56px;
    padding-top: 8px;
    padding-left: 18px;
    border: 1px none #000;
    border-radius: 4px;
    background-color: hsla(0, 0%, 100%, .7);
    font-size: 16px;
  }

  .location-text-field:active {
    background-color: #fff;
  }

  .location-text-field:focus {
    background-color: #fff;
  }

  .location-text-field::-webkit-input-placeholder {
    color: rgba(0, 0, 0, .3);
  }

  .location-text-field:-ms-input-placeholder {
    color: rgba(0, 0, 0, .3);
  }

  .location-text-field::placeholder {
    color: rgba(0, 0, 0, .3);
  }
</style>
