
<template>
  <div v-if="eventView" >
    <EventSearchListCard
      v-bind="$props" />
  </div>
  <div v-else>
    <UserSearchListCard
      v-bind="$props" />
  </div>
</template>

<script>
import EventSearchListCard from '@/components/search/EventSearchListCard.vue'
import UserSearchListCard from '@/components/search/UserSearchListCard.vue'
import { mapGetters } from 'vuex'

export default {
  name: 'UserOrEventCard',
  props: ['itemType', 'item', 'mapArea'],
  components: { EventSearchListCard, UserSearchListCard },
  computed: {
    eventView: function () {
      if (this.itemType === 'event') { return true } else if (this.itemType === 'all') { return false }
    }
  }
}
</script>
