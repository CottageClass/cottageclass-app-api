<template>
  <div>
    <div v-if="detailView" class="detail-wrapper">
      <EventListMap
        :center="mapArea.center"
        @searchAreaSet="updateMapAreaFromMap"
        :showFetchMoreButton="showFetchMoreButton"
        :items="items"
        :noItemsMessage="noItemsMessage"
        :showTrailblazerMessage="showTrailblazerMessage"
        @fetch-more-click="fetchMoreItems"
        @user-updated="updateUser"
        @event-updated="updateEvent"
        :isFullScreen="true"
        @back-click="detailView=false"
      />
    </div>

    <div v-else class="page-wrapper">
      <MainNav />
      <div class="events__container w-container">
        <div class="events__column-left">
          <MainActionButtons @offer-playdate-click="offerPlaydate"/>
          <div class="list-container w-container">
            <FilterSelectorBank :showEventTimeFilter="itemType==='event'"/>
            <SearchResultList
              :itemType="itemType"
              :awaiting="awaiting"
              :showFetchMoreButton="showFetchMoreButton"
              class="list"
              :items="items"
              :noItemsMessage="noItemsMessage"
              :showTrailblazerMessage="showTrailblazerMessage"
              @fetch-more-click="fetchMoreItems"
              @user-updated="updateUser"
              @event-updated="updateEvent"/>
          </div>

        </div>
        <div class="events__column-right">
          <div class="map-container">
            <EventListMap
              class="map"
              :items="items"
              @map-click="handleMapClick"
              @searchAreaSet="updateMapAreaFromMap"
              :isFullScreen="false"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from 'vuex'

import MainActionButtons from '@/components/search/MainActionButtons'
import SearchResultList from '@/components/SearchResultList'
import MainNav from '@/components/MainNav'
import EventListMap from '@/components/EventListMap'
import FilterSelectorBank from '@/components/filters/FilterSelectorBank'

import { alerts, screen } from '@/mixins'

export default {
  name: 'Search',
  mixins: [alerts, screen],
  props: ['itemType'],
  components: {
    MainActionButtons,
    SearchResultList,
    MainNav,
    EventListMap,
    FilterSelectorBank
  },
  data () {
    return {
      showAllButtonText: 'Show all playdates',
      showShowAllButton: false,
      noItemsMessage: 'Sorry, there are no upcoming playdates in this area',
      showTrailblazerMessage: true,
      detailView: false,
      awaiting: false
    }
  },
  computed: {
    ...mapGetters(['currentUser', 'isAuthenticated', 'alert', 'mapArea', 'items', 'showFetchMoreButton'])
  },
  methods: {
    handleMapClick () {
      if (this.isMobile) {
        this.detailView = true
      }
    },
    offerPlaydate () {
      this.$router.push({ name: 'NewEvent' })
    },
    async fetchMoreItems () {
      try {
        this.awaiting = true
        await this.fetchMoreItems()
      } catch (e) {
        this.logError('problem loading more items')
        this.logError(e)
      } finally {
        this.awaiting = false
      }
    },
    updateMapAreaFromMap: async function (e) {
      const center = e.center ? { lat: e.center.lat(), lng: e.center.lng() } : null
      this.setMapArea({
        center,
        maxDistance: e.miles
      })
    },
    ...mapActions(['fetchMoreItems', 'fetchItems', 'setMapArea']),
    ...mapMutations(['updateUser', 'updateEvent', 'setItemType'])
  },
  watch: {
    '$route': {
      handler () {
        this.setItemType({ itemType: this.$route.name })
        this.fetchItems()
      }
    }
  },
  created: async function () {
    if (this.currentUser && !this.currentUser.place) {
      await this.$store.dispatch('updateCurrentUserFromServer')
    }
    if (this.currentUser && !this.currentUser.profileBlurb) {
      this.$router.push({ name: 'ProfileCollection' })
    } else {
      if (!this.items) {
        this.fetchItems()
      }
    }
  }
}
</script>

<style scoped lang="scss">
.events__container {
  position: relative;
  display: flex;
  margin-top: 32px;
  padding-right: 32px;
  padding-bottom: 0;
  padding-left: 32px;
  align-items: flex-start;
}

.events__column-left {
  width: 50%;
  min-height: 100px;
  margin-right: 32px;
  padding-bottom: 80px;
}

.events__column-right {
  position: sticky;
  top: 0;
  width: 50%;
}

.map {
  display: flex;
  min-height: 100vh;
  min-width: 320px;
  justify-content: center;
  align-items: flex-start;
  background-position: 50% 50%;
  background-size: auto;
  background-repeat: no-repeat;
  background-attachment: scroll;
}

.map-container {
  height: 100vh;
  min-height: 300px;
  min-width: 320px;
}

@media (max-width: 991px){
  .events__container {
    margin-top: 0;
    flex-direction: column-reverse;
    padding-right: 0;
    padding-left: 0;
  }

  .events__column-left {
    width: 100%;
    margin-right: 0;
    margin-bottom: 0;
    padding-right: 0;
    padding-left: 0;
  }

  .events__column-right {
    position: static;
    display: block;
    width: 100%;
    margin-bottom: 0;
    padding-right: 0;
    padding-left: 0;
  }

  .map {
    min-height: 240px;
    min-width: 100%;
    background-position: 50% 50%;
    background-size: auto;
  }

  .map-container {
    height: auto;
    max-width: 100%;
    min-height: 240px;
    min-width: auto;
  }

}

@media (max-width: 767px){
  .events__container {
    position: static;
  }

  .map {
    min-height: 200px;
  }

  .map-container {
    min-height: 200px;
  }

}
</style>
