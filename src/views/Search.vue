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
      <div class="content-section background-01">
        <div class="divider-2px"></div>
        <div class="top-container w-container">
          <h1 class="event-page-title">Meet new parents. Plan playdates.</h1>
          <div class="selectors-group">
          <div class="filter-container">

            <FilterSelector title="Location"
                            :showClear="false"
                            :active="shortDescription" >
              <template v-slot:buttonContents>
                <LocationFilterButton :shortDescription="shortDescription" />
              </template>
              <template v-slot:selectorContents>
                <LocationFilterSelector
                  @locationUpdated="updateMapAreaFromFilter"
                  :searchRadius="mapArea.maxDistance"
                />
              </template>
            </FilterSelector>

            <FilterSelector title="Child Age"
                            :showClear="true"
                            @clearFilterClicked="resetAgeRange"
                            :active="ageRangeActive" >
              <template v-slot:buttonContents>
                <AgeRangeFilterButton :range="ageRange" />
              </template>
              <template v-slot:selectorContents>
                <AgeRangeFilterSelector
                  v-model="ageRange"
                />
              </template>
            </FilterSelector>
          </div>
        </div>
        <div class="page-subtitle"><strong>These parents near you want to share playdates.</strong> Offer a playdate, contact parents to invite them, or browse scheduled playdates below!</div>
        </div>
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
              <SearchResultList
                :showFetchMoreButton="showFetchMoreButton"
                class="list"
                :items="items"
                :noItemsMessage="noItemsMessage"
                :showTrailblazerMessage="showTrailblazerMessage"
                @offer-click="offerPlaydate"
                @request-childcare-click="requestChildcare"
                @fetch-more-click="fetchMoreItems"
                @user-updated="updateUser"
                @event-updated="updateEvent"/>
            </div>
          </div>
        </div>
        <Footer />
      </div>
    </div>
  </div>
</template>

<script>
import SearchResultList from '@/components/SearchResultList.vue'
import MainNav from '@/components/MainNav.vue'
import Footer from '@/components/Footer.vue'
import EventListMap from '@/components/EventListMap.vue'
import FilterSelector from '@/components/filters/FilterSelector'
import AgeRangeFilterButton from '@/components/filters/AgeRangeFilterButton'
import AgeRangeFilterSelector from '@/components/filters/AgeRangeFilterSelector'
import LocationFilterSelector from '@/components/filters/LocationFilterSelector'
import LocationFilterButton from '@/components/filters/LocationFilterButton'

import { messaging, alerts, screen } from '@/mixins'
import { fetchFeed } from '@/utils/api'
import { mapGetters } from 'vuex'

export default {
  name: 'Search',
  mixins: [messaging, alerts, screen],
  components: { SearchResultList,
    MainNav,
    Footer,
    EventListMap,
    FilterSelector,
    AgeRangeFilterSelector,
    AgeRangeFilterButton,
    LocationFilterSelector,
    LocationFilterButton },
  data () {
    return {
      showAllButtonText: 'Show all playdates',
      showShowAllButton: false,
      noItemsMessage: 'Sorry, there are no upcoming playdates in this area',
      items: null,
      lastPage: 0,
      showFetchMoreButton: true,
      showTrailblazerMessage: true,
      ageRange: { error: null, data: { min: -1, max: -1 } },
      detailView: false,
      shortDescription: null
    }
  },
  computed: {
    ageRangeActive () {
      return this.ageRange.data.min >= 0 || this.ageRange.data.max >= 0
    },
    ...mapGetters(['currentUser', 'isAuthenticated', 'alert', 'mapArea'])
  },
  methods: {
    handleMapClick () {
      if (this.isMobile) {
        this.detailView = true
      }
    },
    updateUser (user) {
      const userIndex = this.items.findIndex(i => i.user.id === user.id)
      this.items[userIndex].user = user
    },
    updateEvent (event) {
      const eventIndex = this.items.findIndex(i => i.event.id === event.id)
      this.items[eventIndex].event = event
    },
    offerPlaydate () {
      this.$router.push({ name: 'NewEvent' })
    },
    requestChildcare () {
      this.$router.push({ name: 'RequestChildcare' })
    },
    async fetchMoreItems () {
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
    resetAgeRange () {
      this.ageRange = { error: null, data: { min: -1, max: -1 } }
    },
    updateMapAreaFromMap: async function (e) {
      this.updateMapArea(e)
      this.shortDescription = null
    },
    updateMapAreaFromFilter: async function (e) {
      this.updateMapArea(e)
      this.shortDescription = e.shortDescription
    },
    updateMapArea: async function (e) {
      const center = e.center ? { lat: e.center.lat(), lng: e.center.lng() } : null
      this.$store.commit('setMapArea', {
        center,
        maxDistance: e.miles
      })
      this.showTrailblazerMessage = false
      this.fetch()
    },
    fetch: async function () {
      this.items = null
      this.lastPage = 0
      this.showFetchMoreButton = true
      this.fetchMoreItems()
    }
  },
  watch: {
    ageRange: {
      handler: function () {
        this.fetch()
      },
      deep: true
    }
  },
  created: async function () {
    if (this.currentUser && !this.currentUser.profileBlurb) {
      this.$router.push({ name: 'ProfileCollection' })
    } else {
      this.settlePendingWaves()
      this.fetch()
    }
  }
}
</script>

<style scoped lang="scss">
.detail-wrapper {
  height: 100vh;
  width: 100%;
}
.filter-container {
  display: flex;
  flex-direction: row;
  & > div{
    margin-right:10px;
  }
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

.page-subtitle {
  font-size: 15px;
  line-height: 19px;
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
  background-color: #fff;
}

.content-section.background-01 {
  background-color: #f6f6f6;
}

.divider-2px {
  width: 100%;
  height: 2px;
  background-color: #f3f3f3;
}

.list-container {
  display: flex;
  width: 568px;
  min-height: 100px;
  padding-right: 32px;
  flex-direction: column;
  align-items: flex-start;
  background-color: transparent;
}

.map {
  position: sticky;
  top: 32px;
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

.event-page-title {
  margin-bottom: 11px;
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
    padding-top: 20px;
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
  }
  .event-page-title {
    font-size: 32px;
    line-height: 42px;
  }
}
@media (max-width: 767px){
  .main-container {
    padding: 0px;
  }
  .event-page-title {
      font-size: 28px;
      line-height: 34px;
  }
}
@media (max-width: 479px) {
  .event-page-title {
    font-size: 24px;
    line-height: 31.200000000000003px;
  }
}

</style>
