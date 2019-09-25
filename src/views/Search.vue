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
        <GetTheMost
          @offer-playdate-click="offerPlaydate"
          @request-childcare-click="requestChildcare"
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
              <li class="events-list__title-bar">
                <div class="other-events__title-text">Nearby Parents</div>
                <div class="selectors-group">
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

                  <div class="utility-spacer-16px"></div>

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
              </li>
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
import GetTheMost from '@/components/search/GetTheMost.vue'
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
  components: {
    GetTheMost,
    SearchResultList,
    MainNav,
    Footer,
    EventListMap,
    FilterSelector,
    AgeRangeFilterSelector,
    AgeRangeFilterButton,
    LocationFilterSelector,
    LocationFilterButton
  },
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
      awaiting: false,
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
      const userItems = this.items.filter(i => i.user.id === user.id)
      for (const item of userItems) {
        item.user = user
      }
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
        this.awaiting = true
        let newItems = await fetchFeed(params)
        if (newItems.length < params.pageSize) {
          this.showFetchMoreButton = false
        }
        // if items is null, set it to the incoming items, otherwise add them
        this.items = !this.items ? newItems : this.items.concat(newItems)
        this.lastPage = this.lastPage + 1
      } catch (e) {
        this.logError('problem loading more items')
        this.logError(e)
      } finally {
        this.awaiting = false
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
      if (!this.items) {
        this.fetch()
      }
    }
  }
}
</script>

<style scoped lang="scss">
.events-list__title-bar {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 100%;
  margin-top: 0px;
  padding: 16px 20px 18px;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  -webkit-flex-direction: row;
  -ms-flex-direction: row;
  flex-direction: row;
  -webkit-box-pack: justify;
  -webkit-justify-content: space-between;
  -ms-flex-pack: justify;
  justify-content: space-between;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.other-events__title-text {
  overflow: hidden;
  margin-right: 16px;
  font-size: 16px;
  line-height: 24px;
}

.selectors-group {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  -webkit-flex-direction: row;
  -ms-flex-direction: row;
  flex-direction: row;
  -webkit-box-pack: end;
  -webkit-justify-content: flex-end;
  -ms-flex-pack: end;
  justify-content: flex-end;
  -webkit-box-align: start;
  -webkit-align-items: flex-start;
  -ms-flex-align: start;
  align-items: flex-start;
}

.filter-btn-container-alt {
  margin-bottom: 0px;
  -webkit-box-flex: 0;
  -webkit-flex: 0 0 auto;
  -ms-flex: 0 0 auto;
  flex: 0 0 auto;
}

.utility-spacer-16px {
  padding: 0px 8px;
}

.btn-filter {
  margin-right: 0px;
  padding: 4px 10px 5px;
  border: 1px solid #1f88e9;
  border-radius: 4px;
  background-color: transparent;
  color: #1f88e9;
  font-size: 13px;
}

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
  .event-page-title {
    font-size: 32px;
    line-height: 42px;
  }
}
@media (max-width: 767px){
  .events-list__title-bar {
    padding: 16px;
    border-radius: 0px;
  }

  .other-events__title-text {
    font-size: 14px;
    line-height: 18px;
  }

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
