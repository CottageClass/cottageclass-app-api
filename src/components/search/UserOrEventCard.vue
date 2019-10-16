
<template>

    <div v-if="eventView" >
        <div v-for="item in (items || [])">
        <EventSearchListCard 
          :item="item"
          :distanceCenter="mapArea.center"
          :key="item.id"
          @user-updated="$emit('user-updated', $event)"
          @event-deleted="$emit('event-deleted', id)"
          @event-updated="$emit('event-updated', $event)"/>
        </div>
    </div>
    <div v-else>
        <div v-for="item in (items || [])">
        <UserSearchListCard 
          :item="item"
          :distanceCenter="mapArea.center"
          :key="item.id"
          @user-updated="$emit('user-updated', $event)"
          @event-deleted="$emit('event-deleted', id)"
          @event-updated="$emit('event-updated', $event)"/>
        </div>
    </div>
    
</template>

<script>
import EventSearchListCard from '@/components/search/EventSearchListCard.vue'
import UserSearchListCard from '@/components/search/UserSearchListCard.vue'

export default {
    name: 'UserOrEventCard',
    props: ['itemType', 'items', 'mapArea'],
    components: { EventSearchListCard, UserSearchListCard },
    computed: {
        eventView: function (){
            if (this.itemType === 'event'){return true}
            else if (this.itemType === 'all'){return false}
        }
    }
}
</script>