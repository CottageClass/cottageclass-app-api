<!--
This is the map view or the list view of events
 -->

<template>
  <div class="lp-container">
    <div v-if="isFullScreen" class="top-container">
      <a
      v-if="isFullScreen"
      @click="$emit('back-click')"
      class="back-button w-inline-block">
        <img src="../assets/arrow-back-black.svg">
      </a>
      <a
      v-if="isFullScreen"
      @click="switchType"
      class="toggle-button w-inline-block">
        <div>{{ otherType }}</div>
      </a>

    </div>
    <div v-show="type==='map'"
         class="map-wrapper"
         :class="{full: isFullScreen}"
         @click="mapClick">
      <transition name="fade">
        <a v-if="showSearchButton"
          href=""
          @click.prevent="searchButtonClick"
          class="map-button-1 w-button">
          Search this area
        </a>
      </transition>
      <div ref="map" class="map-container" />
    </div>
    <div
    v-if="type==='list'"
    class="list-container w-container">
      <SearchResultList
              :showFetchMoreButton="showFetchMoreButton"
              class="list"
              :items="items"
              :noItemsMessage="noItemsMessage"
              :showTrailblazerMessage="showTrailblazerMessage"
              @offer-playdate-click="offerPlaydate"
              @request-childcare-click="requestChildcare"
              @fetch-more-click="$emit('fetch-more-click')"
              @user-updated="$emit('user-updated', $event)"
              @event-updated="$emit('event-updated', $event)"/>
    </div>
  </div>
</template>

<script>
import { maps, screen } from '@/mixins'
import SearchResultList from '@/components/SearchResultList.vue'
import { mapGetters } from 'vuex'

export default {
  name: 'EventListMap',
  props: [ 'items', 'showFetchMoreButton', 'noItemsMessage', 'showTrailblazerMessage', 'isFullScreen' ],
  mixins: [ maps, screen ],
  components: { SearchResultList },
  data () {
    return {
      map: null,
      type: 'map',
      userPins: [],
      mapHasChanged: false,
      noIdlesYet: true
    }
  },
  methods: {
    offerPlaydate () {
      this.$router.push({ name: 'NewEvent' })
    },
    requestChildcare () {
      this.$router.push({ name: 'RequestChildcare' })
    },
    mapClick () {
      this.$emit('map-click')
    },
    switchType () {
      this.type = this.otherType
    },
    updateMarkers: async function () {
      await this.map
      for (let pin of this.userPins) {
        pin.setMap(null)
      }
      this.eventCircles = []
      this.userPins = []

      const that = this
      // sort users by latitude when adding pins so the z index is right on the map
      if (this.users) {
        const latUsers = this.users.concat().sort((a, b) => {
          return b.location.lat - a.location.lat
        })

        for (let user of latUsers) {
          const pin = await that.addUserPin(
            user,
            { lat: user.location.lat, lng: user.location.lng }
          )
          if (pin) {
            that.userPins.push(pin)
            pin.addListener('click', function () {
              that.$router.push({ name: 'UserPage', params: { id: user.id } })
            })
          }
        }
      }
    },
    searchButtonClick: async function () {
      const map = await this.map
      this.mapHasChanged = false
      const radius = await this.radiusFromMap()
      this.$emit('searchAreaSet', { center: map.center, miles: radius })
    },
    idleHandler (e) {
      if (this.noIdlesYet) {
        this.noIdlesYet = false
      } else {
        this.mapHasChanged = true
      }
    }
  },
  computed: {
    users () {
      return this.items && this.items.map(i => i.user)
    },
    showSearchButton () {
      return (this.isFullScreen || !this.isMobile) && this.mapHasChanged
    },
    noEventsMessage () {
      return 'Sorry, there are no upcoming playdates in this area'
    },
    otherType: function () {
      if (this.type === 'map') {
        return 'list'
      }
      if (this.type === 'list') {
        return 'map'
      }
      throw Error('Type is neither list nor map')
    },
    mapOptions: function () {
      return {
        gestureHandling: this.isFullScreen || !this.isMobile ? 'greedy' : 'none',
        zoomControl: !this.isMobile,
        mapTypeControl: false,
        scaleControl: false,
        streetViewControl: false,
        rotateControl: false,
        fullscreenControl: false
      }
    },
    ...mapGetters([ 'mapArea' ])
  },
  watch: {
    users: function () {
      this.updateMarkers()
    },
    mapArea: {
      handler: async function () {
        const map = await this.map
        map.setCenter(this.mapArea.center)
        this.setZoomLevelForRadius(this.mapArea.maxDistance)
      },
      deep: true
    }
  },
  mounted: async function () {
    this.$nextTick(async function () {
      const center = await this.latlng(this.mapArea.center.lat, this.mapArea.center.lng)
      await this.createMap(this.$refs.map, {
        zoom: 13,
        center: center,
        ...this.mapOptions
      },
      this.idleHandler.bind(this))
      this.setZoomLevelForRadius(2)
    })
    if (this.users && this.users.length) {
      this.updateMarkers()
    }
  }
}
</script>

<style scoped lang="scss">
select {
  appearance: menulist;
  --webkit-appearance: menulist;
}

.lp-container {
  display: flex;
  flex-direction: column;
  background-color: #f6f6f6;
}

.map-wrapper {
  height: 412px;
  min-width: 100%;
  background-position: 50% 50%;
  background-size: cover;
  position: relative;
  display: flex;
  width: 100%;
  flex-direction: row;
  justify-content: center;
  align-items: flex-start;
  background-color: #fff;
}

.map-button-1 {
  position: absolute;
  top: 0%;
  z-index: 1000;
  width: auto;
  margin-top: 12px;
  padding: 12px 16px;
  -webkit-align-self: flex-end;
  -ms-flex-item-align: end;
  align-self: flex-end;
  border: 1px solid #1f88e9;
  border-radius: 4px;
  background-color: #1f88e9;
  box-shadow: 0 1px 20px 0 rgba(0, 0, 0, .4);
  opacity: 0.9;
  font-weight: 400;
  text-align: center;
}

.map-button-1:hover {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
}

.map-button-1:active {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
}

.map-container {
  height: 100%;
  width: 100%;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity .2s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}

@media (max-width: 991px) {
  .map-wrapper {
    &.full {
      height: 100vh;
    }
    height: 200px;
    flex: 1;
  }

  .top-container {
    display: flex;
    flex-direction: row;
    height: 48px;
    justify-content: space-between;
    align-items: center;
    background-color: white;
  }

  .back-button {
    display: flex;
    padding-left: 10px;
  }

  .toggle-button {
    display: flex;
    color: #1f88e9;
    letter-spacing: 1px;
    text-transform: uppercase;
    text-decoration: none;
    width: 66px;
    height: 48px;
    font-size: 13px;
    text-align: center;
    border-left: 1px solid rgba(0, 0, 0, .04);
    align-items: center;
    div {
      margin: auto;
    }
  }
  .list-container {
    flex: 1;
    overflow-y: scroll;
    padding-bottom: 53px;
  }
}
</style>
