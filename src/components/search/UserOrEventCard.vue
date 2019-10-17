
<template>
  <div v-if="eventView" >
    <EventSearchListCard
      v-bind="$props"
      @user-updated="$emit('user-updated', $event)"
      @event-deleted="$emit('event-deleted', id)"
      @event-updated="$emit('event-updated', $event)" />
  </div>
  <div v-else>
    <UserSearchListCard
      v-bind="$props"
      @user-updated="$emit('user-updated', $event)"
      @event-deleted="$emit('event-deleted', id)"
      @event-updated="$emit('event-updated', $event)" />
  </div>
</template>

<script>
import EventSearchListCard from '@/components/search/EventSearchListCard.vue'
import UserSearchListCard from '@/components/search/UserSearchListCard.vue'

export default {
  name: 'UserOrEventCard',
  props: ['itemType', 'item', 'mapArea'],
  components: { EventSearchListCard, UserSearchListCard },
  computed: {
    eventView: function () {
      if (this.itemType === 'event') { return true } else { return false }
    }
  }
}
</script>
