<template>
  <div>
    <div v-if="detailView" class="detail-wrapper">
      <EventListMap
        :center="mapArea.center"
        @searchAreaSet="updateMapAreaFromMap"
        :showFetchMoreButton="showFetchMoreButton"
        :items="items(itemType)"
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
      <div class="content-section">
        <div class="divider-2px"></div>
        <GetTheMost
          @offer-playdate-click="offerPlaydate"
        />
        <div class="main-container w-container">

          <div class="map-list-container">
            <EventListMap
              class="map"
              :items="items"
              @map-click="handleMapClick"
              @searchAreaSet="updateMapAreaFromMap"
              :isFullScreen="false"
            />
            <div class="list-container w-container">
              <FilterSelectorBank />
              <SearchResultList
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
        </div>
        <Footer
          :hideOnMobile = true
        />
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from 'vuex'

import GetTheMost from '@/components/search/GetTheMost'
import SearchResultList from '@/components/SearchResultList'
import MainNav from '@/components/MainNav'
import Footer from '@/components/Footer'
import EventListMap from '@/components/EventListMap'
import FilterSelectorBank from '@/components/filters/FilterSelectorBank'

import { messaging, alerts, screen } from '@/mixins'

export default {
  name: 'Search',
  mixins: [messaging, alerts, screen],
  props: {
    itemType: { default: 'Events' }
  },
  components: {
    GetTheMost,
    SearchResultList,
    MainNav,
    Footer,
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
      this.fetchItems()
    },
    ...mapActions(['fetchMoreItems', 'fetchItems', 'setMapArea']),
    ...mapMutations(['updateUser', 'updateEvent', 'setItemType'])
  },
  watch: {
    ageRange: {
      handler: function () {
        this.fetchItems()
      },
      deep: true
    },
    '$route': {
      handler () {
        this.setItemType({ itemType: this.$route.name })
        this.fetchItems()
      }
    }
  },
  created: async function () {
    if (this.currentUser && !this.currentUser.profileBlurb) {
      this.$router.push({ name: 'ProfileCollection' })
    } else {
      this.settlePendingWaves()
      if (!this.items) {
        this.fetchItems()
      }
    }
  }
}
</script>

<style scoped lang="scss">

.detail-wrapper {
  height: 100vh;
  width: 100%;
}

.page-wrapper {
  all: unset;
  font-family: soleil, sans-serif;
  color: #333;
  font-size: 14px;
  line-height: 20px;
  background-color: #fff;
  overflow: visible;
  background-color: #fff;
}

.map-list-container {
  display: flex;
  flex-direction: row-reverse;
  margin-right: auto;
  margin-left: auto;
}

h2 {
  margin-top: 20px;
  margin-bottom: 10px;
  font-size: 32px;
  line-height: 36px;
  font-weight: bold;
}

a {
  color: #000;
  text-decoration: none;
}

.content-section {
  display: block;
  margin-top: 0px;
  align-items: center;
  background-color: #f6f6f6;
}

.divider-2px {
  width: 100%;
  height: 2px;
  background-color: #f3f3f3;
}

.list-container {
  display: flex;
  width: 555px;
  min-height: 100px;
  padding-right: 32px;
  flex-direction: column;
  align-items: flex-start;
  background-color: transparent;
}

.map {
  position: sticky;
  top: 146px;
  display: block;
  width: 320px;
  height:438px;
  clear: none;
  border-top-left-radius: 4px;
  border-top-right-radius: 4px;
}

.top-container {
  position: relative;
  display: flex;
  padding-right: 32px;
  padding-bottom: 24px;
  padding-left: 32px;
  flex-direction: column;
}

.main-container {
  position: relative;
  min-height: 800px;
  display: flex;
  margin-bottom: 100px;
  margin-left: auto;
  margin-right: auto;
  padding: 40px 32px;
  flex-direction: row;
  justify-content: flex-start;
  align-items: flex-start;
}

@media (max-width: 991px) {
  .map {
    position: relative;
    top: 0;
    width: 100%;
    height: 200px;
    cursor:s-resize;
  }
  .list-container {
    width:100%;
    padding-top: 0px;
    padding-right: 0px;
    padding-bottom: 128px;
  }
  .map-list-container {
    width: 100%;
    margin: 0;
    display: flex;
    flex-direction: column;
  }
  .main-container {
    padding: 0px 32px 80px;
    margin-top: 0px;
  }
}

@media (max-width: 767px){
  .main-container {
    padding: 0px;
  }
}
</style>
