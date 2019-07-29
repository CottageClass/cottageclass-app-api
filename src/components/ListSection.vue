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
    <li class="card" v-if="hasSlot">
    <slot />
    </li>
    <SearchListCard v-for="item in items"
                    :key="item.id"
                    :item="item"
                    @event-deleted="$emit('event-deleted')"
                    @event-updated="$emit('event-updated')"
                    />

  </ul>
</div>
</template>

<script>
import ListSectionHeader from '@/components/ListSectionHeader'
import ListSectionEmptyCard from '@/components/ListSectionEmptyCard'
import LoadingSpinner from '@/components/LoadingSpinner'
import SearchListCard from '@/components/search/SearchListCard'

export default {
  name: 'ListSection',
  components: { ListSectionHeader, ListSectionEmptyCard, LoadingSpinner, SearchListCard },
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
.card {
  display: flex;
  width: 100%;
  margin-top: 0;
  margin-bottom: 4px;
  padding: 16px 20px 18px;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}
@media (max-width: 767px){
  .card {
    margin-bottom: 0;
    padding: 16px;
    border-radius: 0;
  }

}
</style>
