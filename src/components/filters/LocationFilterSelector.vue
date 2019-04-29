<template>
  <div class="selector-wrapper">
    <div class="section-title">Address</div>

    <vue-google-autocomplete
      id="address-autocomplete"
      classname="location-text-field w-input"
      placeholder="Search..."
      v-on:placechanged="updateAddress"
      country="us"
    >
    </vue-google-autocomplete>
    <div class="section-title">Within Distance</div>
    <v-slider
      v-model="distanceIndex"
      min="0"
      :max="distanceOptions.length - 1"
      @change="update"
    ></v-slider>
    <div class="distance-display">{{ distanceText }}</div>
  </div>
</template>

<script>
import VueGoogleAutocomplete from 'vue-google-autocomplete'
import { mapGetters } from 'vuex'

export default {
  name: 'LocationFilterSelector',
  components: { VueGoogleAutocomplete },
  props: ['searchRadius'],
  data () {
    return {
      distanceIndex: null,
      distanceOptions: [0.1, 0.2, 0.5, 1, 2, 5, 10, 20],
      err: null,
      zip: null
    }
  },
  computed: {
    initialIndex () {
      if (!this.searchRadius) {
        return Math.round(this.distanceOptions.length / 2)
      }
      return this.distanceOptions.reduce((bestIndex, currentDistance, currentIndex) => {
        if (Math.abs(this.distanceOptions[currentIndex] - this.searchRadius) <
            Math.abs(this.distanceOptions[bestIndex] - this.searchRadius)) {
          return currentIndex
        } else {
          return bestIndex
        }
      }, 0)
    },
    distance () {
      return this.distanceOptions[this.distanceIndex]
    },
    distanceText () {
      return this.distance + ' Mile' + (this.distance === 1 ? '' : 's')
    },
    ...mapGetters(['mapArea'])
  },
  mounted () {
    this.distanceIndex = this.initialIndex
  },
  methods: {
    update () {
      this.$emit('locationUpdated', {
        center: this.center,
        miles: this.distance,
        zip: this.zip
      })
    },
    updateAddress (addressData) {
      this.center = {
        lat: () => addressData.latitude,
        lng: () => addressData.longitude
      }
      this.zip = addressData.postal_code
      this.update()
    }
  }
}
</script>

<style scoped lang="scss">
.section-title {
    width: auto;
    margin-bottom: 8px;
}
.distance-display {
  text-align: center;
}
.location-text-field {
  width: 100%;
  height: 50px;
  margin-bottom: 20px;
  padding-top: 6px;
  border: 1px solid transparent;
  border-radius: 4px;
  background-color: rgba(0, 0, 0, .04);
  font-size: 16px;
  font-weight: 400;
}

.selector-wrapper {
  width:100%;
}

.dropdown {
  padding: 16px;
}

.label {
  padding: 4px;
}
.pac-item, .pac-container {
  width : 500px !important;
}
</style>
