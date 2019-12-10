<template>
  <div class="action-selector-overlay"
       @click.stop="$emit('clickaway')"
       @touchmove="preventTouchMove"
  >
    <div class="other-events-card_action-selector">
      <SearchListCardActions
        :user="user"
        :event="event"
        @user-updated="$emit('user-updated', $event)"
        @event-deleted="$emit('event-deleted', id)"
        @event-updated="$emit('event-updated', $event)"
        @event-series-updated="$emit('event-series-updated', $event)"
        @going-click="$emit('going-click')"
        @contact-click="$emit('contact-click')"
        @cancel-click="$emit('cancel-click')"
        @interested-click="$emit('interested-click')"
        @share-click="$emit('share-click')"
        class="other-events-card__action-selector__button-list"
        :showGoingButton="showGoingButton"
        :showContactButton="showContactButton"
        :showCancelButton="showCancelButton"
        :showShareButton="showShareButton"
        :showInterestedButton="showInterestedButton"
      />
    </div>
  </div>
</template>

<script>
import SearchListCardActions from '@/components/search/SearchListCardActions'
export default {
  name: 'SearchListCardActionsOverlay',
  props: {
    showGoingButton: { default: false },
    showInterestedButton: { default: false },
    showContactButton: { default: false },
    showCancelButton: { default: false },
    user: { required: true },
    event: {}
  },
  components: { SearchListCardActions },
  methods: {
    preventTouchMove (e) {
      e.preventDefault()
      e.stopPropagation()
    }
  }
}
</script>

<style scoped lang="scss">
.action-selector-overlay {
  display: block;
}

.other-events-card_action-selector {
  position: absolute;
  left: auto;
  top: 26px;
  right: 6px;
  bottom: auto;
  z-index: 1000;
  display: block;
  width: 180px;
  margin-top: 4px;
  padding: 20px 20px 12px;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: 1px 1px 24px 0 rgba(0, 0, 0, 0.2);
}

.other-events-card__action-selector__button-list {
  display: flex;
  width: 100%;
  margin-top: 0;
  margin-right: -8px;
  margin-bottom: 0;
  padding-left: 0;
  flex-direction: column;
  list-style-type: none;
}

@media (max-width: 991px){
  .action-selector-overlay {
    display: block;
  }

}

@media (max-width: 767px){
  .action-selector-overlay {
    position: fixed;
    left: 0;
    top: 0;
    right: auto;
    bottom: auto;
    z-index: 2000;
    display: block;
    width: 100%;
    height: 10000px;
    padding-top: 16px;
    padding-right: 16px;
    padding-left: 16px;
    border-radius: 0;
    background-color: rgba(0, 0, 0, 0.4);
  }

  .other-events-card_action-selector {
    position: relative;
    z-index: 3000;
    display: block;
    width: 100%;
    min-height: 100px;
    margin-top: 0;
    margin-right: 0;
    margin-left: 6px;
  }

}

@media (max-width: 479px){
  .other-events-card__action-selector__button-list {
    width: 100%;
    flex-direction: column;
  }

}
</style>
