<!--
This is the mobile-only page that shows an expanded, naviagable map of events
 -->

<template>
  <div class="body">
    <EventListMap
      class="map"
      :users="users"
      :events="events"
      @maxDistanceSet="updateForZoomLevel($event)"
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
      users: null,
      events: null
    }
  },
  computed: {
    center () {
      if (this.currentUser) {
        return { lat: this.currentUser.latitude, lng: this.currentUser.longitude }
      } else {
        return { lat: 40.688309, lng: -73.994639 } // BoCoCa
      }
    },
    ...mapGetters([
      'currentUser', 'isAuthenticated', 'mapArea'
    ])
  },
  methods: {
    updateForZoomLevel: async function (e) {
      console.log(this.mapArea)
      this.$store.commit('setMapArea', {
        center: { lat: e.center.lat(), lng: e.center.lng() },
        maxDistance: e.miles
      })
      this.fetchWithinDistance()
    },
    fetchWithinDistance: async function () {
      const params = {
        miles: this.mapArea.maxDistance,
        lat: this.mapArea.center.lat,
        lng: this.mapArea.center.lng,
        pageSize: 10
      }
      console.log({ params })
      this.events = await fetchUpcomingEventsWithinDistance(params)
      this.users = await fetchUsersWithinDistance(params)
    }
  },
  mounted: async function () {
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
