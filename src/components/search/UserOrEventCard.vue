
<template>
    <div v-if="isPlaydatesPage" >
        <EventSearchListCard 
          :item="item"
          :distanceCenter="mapArea.center"
          :key="item.id"
          @user-updated="$emit('user-updated', $event)"
          @event-deleted="$emit('event-deleted', id)"
          @event-updated="$emit('event-updated', $event)"/>
    </div>
    <div v-else>
        <UserSearchListCard 
          :itemType="itemType"
          :item="item"
          :distanceCenter="mapArea.center"
          :key="item.id"
          @user-updated="$emit('user-updated', $event)"
          @event-deleted="$emit('event-deleted', id)"
          @event-updated="$emit('event-updated', $event)"/>
    </div>
</template>

<script>
import EventSearchListCard from '@/components/search/EventSearchListCard.vue'
import UserSearchListCard from '@/components/search/UserSearchListCard.vue'
export default {
    name: userOrOfferCard,
    props: ['itemType'],
    components: { EventSearchListCard, UserSearchListCard },
    computed: {
        isPlaydatesPage: function (){
            if (itemType === 'Events'){return true}
            else if (itemType === 'Parents'){return false}
        }
    }
}

</script>