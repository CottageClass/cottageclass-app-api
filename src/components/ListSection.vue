<template>
  <div class="utility-cont__margin-bottom-48">
    <ul class="hosting-list">
      <ListSectionHeader :title="title"
                         :buttonText="buttonText"
                         @button-click="$emit('header-button-click')"
      />
      <LoadingSpinner v-if="!items && !hasSlot" />
      <ListSectionEmptyCard v-else-if="items && items.length===0"
                            :options=emptyOptions
                            @button-click="$emit('empty-card-button-click')"
                            @additional-link-click="$emit('empty-card-additional-link-click')"
      />
      <slot />
      <EventSearchListCard v-for="item in items"
                           :key="item.id"
                           :item="item"
                           @event-deleted="$emit('event-deleted')"
                           @event-updated="$emit('event-updated')"
                           @user-updated="$emit('user-updated')"
      />

    </ul>
  </div>
</template>

<script>
import ListSectionHeader from '@/components/ListSectionHeader'
import ListSectionEmptyCard from '@/components/ListSectionEmptyCard'
import LoadingSpinner from '@/components/LoadingSpinner'
import EventSearchListCard from '@/components/search/EventSearchListCard'

export default {
  name: 'ListSection',
  components: { ListSectionHeader, ListSectionEmptyCard, LoadingSpinner, EventSearchListCard },
  props: {
    items: {},
    title: { required: true },
    buttonText: { required: false },
    emptyOptions: { required: false }
  },
  computed: {
    hasSlot () { return !!this.$slots.default }
  }
}
</script>

<style scoped lang="scss">
.hosting-list {
  padding-left: 0;
  list-style-type: none;
}

.utility-cont__margin-bottom-48 {
  margin-bottom: 48px;
}
</style>
