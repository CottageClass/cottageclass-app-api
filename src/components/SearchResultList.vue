<template>
  <div class="list-wrapper">
    <LoadingSpinner v-if="awaiting"/>
    <div class="event-list" v-if="!awaiting">
      <SearchListHeader
        @offerClick="$emit('offerClick')"
        />
      <div v-for="item in items">
        <SearchListCard
                    :user="item.user"
                    :event="item.event"
                    :mapCenter="mapArea.center"
                    :key="'TODOID'"
                    @user-updated="$emit('user-updated', $event)"
                    @event-updated="$emit('event-updated', $event)"/>
      </div>
      <SearchListFooter v-if="showFetchMoreButton"
                        @fetchMoreClick="$emit('fetchMoreClick')"
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
import LoadingSpinner from '@/components/LoadingSpinner'
import SearchListHeader from '@/components/search/SearchListHeader'
import SearchListFooter from '@/components/search/SearchListFooter'
import { mapGetters } from 'vuex'

export default {
  name: 'SearchResultList',
  components: { LoadingSpinner, SearchListCard, TrailblazerCard, SearchListHeader, SearchListFooter },

  props: {
    noEventsMessage: {},
    items: { links: null },
    showTrailblazerMessage: {
      type: Boolean,
      default: false
    },
    showFetchMoreButton: {
      type: Boolean,
      requred: true
    }
  },
  computed: {
    awaiting: function () {
      return this.items === null
    },
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
