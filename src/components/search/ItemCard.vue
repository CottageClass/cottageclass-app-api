<template>
  <component
    v-bind:is="itemCardType"
    v-bind="$props"
    @user-updated="$emit('user-updated', $event)"
    @event-deleted="$emit('event-deleted', id)"
    @event-updated="$emit('event-updated', $event)"
    @event-series-updated="$emit('event-series-updated', $event)"
  />
</template>

<script>
import EventSearchListCard from '@/components/search/EventSearchListCard.vue'
import UserSearchListCard from '@/components/search/UserSearchListCard.vue'

export default {
  name: 'ItemCard',
  props: ['itemType', 'item', 'mapArea'],
  components: { EventSearchListCard, UserSearchListCard },
  computed: {
    itemCardType: function () {
      if (this.itemType === 'event') { return EventSearchListCard } else { return UserSearchListCard }
    }
  }
}
</script>
