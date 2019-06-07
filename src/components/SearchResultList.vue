<template>
  <div class="list-wrapper">
    <LoadingSpinner v-if="awaiting"/>
    <div class="event-list" v-if="!awaiting">
      <div v-for="event in events">
        <SearchListCard
                    :user="eventHost(event)"
                    :event="event"
                    :mapCenter="mapArea.center"
                    :key="'event' + event.id"
                    @user-updated="$emit('user-updated', $event)"
                    @event-updated="$emit('event-updated', $event)"/>
      </div>
      <div v-if="showFetchMoreButton" class="more-link">
        Show more
      </div>
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
import TrailblazerCard from '@/components/TrailblazerCard.vue'
import SearchListCard from '@/components/search/SearchListCard'
import LoadingSpinner from '@/components/LoadingSpinner.vue'
import { mapGetters } from 'vuex'
import { createUser } from '@/utils/createUser'
import normalize from 'json-api-normalizer'

export default {
  name: 'SearchResultList',
  components: { LoadingSpinner, SearchListCard, TrailblazerCard },

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
    eventHost () {
      return (event) => {
        return createUser(normalize(event.host))
      }
    },
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
