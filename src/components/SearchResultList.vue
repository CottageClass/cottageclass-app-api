<template>
  <div class="list-wrapper">
    <div class="event-list">
      <div v-for="item in (items || [])">
        <ItemCard
          :item="item"
          :distanceCenter="mapArea.center"
          :key="item.id"
          :itemType="itemType"
          @user-updated="$emit('user-updated', $event)"
          @event-deleted="$emit('event-deleted', id)"
          @event-series-updated="$emit('event-series-updated', $event)"
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
import SearchListFooter from '@/components/search/SearchListFooter'
import ItemCard from '@/components/search/ItemCard'
import { mapGetters } from 'vuex'

export default {
  name: 'SearchResultList',
  components: { TrailblazerCard, SearchListFooter, ItemCard },
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
    },
    itemType: {
      type: String,
      required: true
    }
  },
  computed: {
    noItems: function () {
      return this.items && this.items.length === 0
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
