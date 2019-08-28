<template>
  <div class="list-wrapper">
    <div class="event-list">
      <SearchListHeader
        v-if="showHeader"
        @offer-playdate-click="$emit('offer-playdate-click')"
        @request-childcare-click="$emit('request-childcare-click')"
      />
      <div v-for="item in (items || [])">
        <SearchListCard
          :item="item"
          :mapCenter="mapArea.center"
          :key="item.id"
          @user-updated="$emit('user-updated', $event)"
          @event-deleted="$emit('event-deleted', id)"
          @event-updated="$emit('event-updated', $event)"/>
      </div>
      <SearchListFooter v-if="showFetchMoreButton"
                        :awaiting="awaiting"
                        @fetch-more-click="$emit('fetch-more-click')"
      />
    </div>
    <!-- in the case of no events -->
    <div v-if="noItems && showTrailblazerMessage">
      <TrailblazerCard />
    </div>
    <p v-if="noItems && !showTrailblazerMessage"
       class="no-events-message"
       v-html="noEventsMessage">
    </p>
  </div>
</template>

<script>
import TrailblazerCard from '@/components/TrailblazerCard'
import SearchListCard from '@/components/search/SearchListCard'
import SearchListHeader from '@/components/search/SearchListHeader'
import SearchListFooter from '@/components/search/SearchListFooter'
import { mapGetters } from 'vuex'

export default {
  name: 'SearchResultList',
  components: { SearchListCard, TrailblazerCard, SearchListHeader, SearchListFooter },

  props: {
    awaiting: {
      type: Boolean,
      default: false
    },
    noEventsMessage: {},
    items: { links: null },
    showTrailblazerMessage: {
      type: Boolean,
      default: false
    },
    showFetchMoreButton: {
      type: Boolean,
      requred: true
    },
    showHeader: {
      type: Boolean,
      default: true
    }
  },
  computed: {
    noItems: function () {
      return this.items !== null && this.items.length === 0
    },
    ...mapGetters(['currentUser', 'distanceFromCurrentUser', 'isAuthenticated', 'mapArea'])
  }
}
</script>

<style lang="scss" scoped>
.list-wrapper {
  display: flex;
  flex-direction: column;
  width: 100%;
}

.no-events-message {
  margin-top: 100px;
}

@media (max-width: 991px) {
  .no-events-message {
    margin: 50px 10px 0;
  }
}

</style>
