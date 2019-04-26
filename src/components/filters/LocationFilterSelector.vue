<template>
  <div class="selector-wrapper">
    <div class="section-title">Address</div>

    <vue-google-autocomplete
      id="address-autocomplete"
      classname="location-text-field w-input"
      placeholder="Search..."
      v-on:placechanged="getAddressData"
      country="us"
    >
    </vue-google-autocomplete>
    <div class="section-title">Within Distance</div>
  </div>
</template>

<script>
import VueGoogleAutocomplete from 'vue-google-autocomplete'

export default {
  name: 'LocationFilterSelector',
  components: { VueGoogleAutocomplete },
  props: ['value'],
  data () {
    return {
      err: null
    }
  },
  methods: {
    update () {
      this.$emit('maxDistanceSet', {
        center: this.center,
        miles: this.distance
      })
    },
    getAddressData (addressData) {
      this.debug({ addressData })
    }
  }
}
</script>

<style scoped lang="scss">
.section-title {
    width: auto;
    margin-bottom: 8px;
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
