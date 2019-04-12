<!--
This is the mobile-only page that shows an expanded, naviagable map of events
 -->

<template>
  <div class="body">
    <EventListMap
      v-if="mapCenter"
      class="map"
      :users="users"
      :events="events"
      @maxDistanceSet="updateForZoomLevel($event)"
      :center="mapCenter"
      :showTrailblazerMessage="showTrailblazerMessage"
    />
  </div>
</template>

<script>
import EventListMap from '@/components/EventListMap.vue'
import { fetchUpcomingEventsWithinDistance, fetchUsersWithinDistance } from '@/utils/api'
import { mapGetters } from 'vuex'

export default {
  name: 'EventsDetail',
  props: ['initialCenter'],
  components: { EventListMap },
  data () {
    return {
      mapCenter: null,
      users: null,
      events: null,
      showTrailblazerMessage: true
    }
  },
  computed: {
    calculateStartingCenter () {
      if (this.currentUser) {
        return { lat: this.currentUser.latitude, lng: this.currentUser.longitude }
      } else if (this.initialCenter) {
        return this.initialCenter
      } else {
        return { lat: 40.688309, lng: -73.994639 } // BoCoCa
      }
    },
    center () {
      if (this.currentUser) {
        return { lat: this.currentUser.latitude, lng: this.currentUser.longitude }
      } else {
        return { lat: 40.688309, lng: -73.994639 } // BoCoCa
      }
    },
    ...mapGetters([
      'currentUser', 'isAuthenticated'
    ])
  },
  methods: {
    updateForZoomLevel: async function (e) {
      this.showTrailblazerMessage = false
      this.mapCenter = { lat: e.center.lat(), lng: e.center.lng() }
      this.maximumDistanceFromUserInMiles = e.miles
      this.fetchWithinDistance()
    },
    fetchWithinDistance: async function () {
      const params = {
        miles: this.maximumDistanceFromUserInMiles,
        lat: this.mapCenter.lat,
        lng: this.mapCenter.lng,
        pageSize: 10
      }
      this.events = await fetchUpcomingEventsWithinDistance(params)
      this.users = await fetchUsersWithinDistance(params)
    }
  },
  mounted: async function () {
    this.mapCenter = await this.calculateStartingCenter
    this.fetchWithinDistance()
  }
}
</script>

<style scoped>
.map {
  height:100%;
  width:100%;
}
.body {
  height: 100vh;
  width: 100%;
}
</style>
