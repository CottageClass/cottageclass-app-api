<!--
This is the mobile-only page that shows an expanded, naviagable map of events
 -->

<template>
  <div class="body">
  <EventListMap
    :center="mapArea.center"
    class="map"
    :clickToExpand="false"
    @searchAreaSet="updateForZoomLevel"
    :showFetchMoreButton="showFetchMoreButton"
    :items="items"
    :noItemsMessage="noItemsMessage"
    :showTrailblazerMessage="showTrailblazerMessage"
    @fetch-more-click="fetchMoreItems"
    @user-updated="updateUser"
    @event-updated="updateEvent"/>
  </div>
</template>

<script>
import { fetchFeed } from '@/utils/api'
import EventListMap from '@/components/EventListMap.vue'
import { mapGetters } from 'vuex'

export default {
  name: 'EventsDetail',
  components: { EventListMap },
  data () {
    return {
      items: null,
      showFetchMoreButton: true,
      showTrailblazerMessage: true,
      noItemsMessage: 'Sorry, there are no upcoming playdates in this area',
      ageRange: { error: null, data: { min: -1, max: -1 } }
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
    updateUser (user) {
      const userIndex = this.items.findIndex(i => i.user.id === user.id)
      this.items[userIndex].user = user
    },
    updateEvent (event) {
      const eventIndex = this.items.findIndex(i => i.event.id === event.id)
      this.items[eventIndex].event = event
    },
    updateForZoomLevel: async function (e) {
      this.$store.commit('setMapArea', {
        center: { lat: e.center.lat(), lng: e.center.lng() },
        maxDistance: e.miles
      })
      this.showTrailblazerMessage = false
      this.fetchWithinDistance()
    },
    async fetchMoreItems () {
      this.debug('fetchMoreItems')
      try {
        const params = {
          miles: this.mapArea.maxDistance,
          lat: this.mapArea.center.lat,
          lng: this.mapArea.center.lng,
          pageSize: 10,
          minAge: this.ageRange.data.min >= 0 ? this.ageRange.data.min : null,
          maxAge: this.ageRange.data.max >= 0 ? this.ageRange.data.max : null,
          page: this.lastPage + 1
        }
        let newItems = await fetchFeed(params)
        if (newItems.length < params.pageSize) {
          this.showFetchMoreButton = false
        }
        if (this.currentUser) {
          newItems = newItems.filter(u => u.id !== this.currentUser.id)
        }
        // if items is null, set it to the incoming items, otherwise add them
        this.items = !this.items ? newItems : this.items.concat(newItems)
        this.lastPage = this.lastPage + 1
      } catch (e) {
        this.logError('problem loading more users')
        this.logError(e)
      }
    },
    fetch: async function () {
      this.items = null
      this.lastPage = 0
      this.showFetchMoreButton = true
      this.fetchMoreItems()
    }
  },
  mounted: async function () {
    this.fetch()
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
