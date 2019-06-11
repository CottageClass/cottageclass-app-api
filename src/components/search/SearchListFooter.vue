<template>
<li class="events-list__view-more"><a @click="$emit('fetchMoreClick')" class="event-list__view-more-link">View more</a></li>
</template>

<script>
export default {
  name: 'SearchListFooter'
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.events-list__view-more {
  position: relative;
  display: flex;
  width: 100%;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
}

.event-list__view-more-link {
  padding: 16px 20px;
  color: #1f88e9;
  font-size: 13px;
  line-height: 15.6px;
}

.event-list__view-more-link:hover {
  background-color: rgba(0, 0, 0, 0.03);
}

@media (max-width: 991px){
  .event-list__view-more-link:hover {
    background-color: transparent;
  }

  .event-list__view-more-link:active {
    background-color: rgba(0, 0, 0, 0.03);
  }

}

@media (max-width: 767px){
  .events-list__view-more {
    border-radius: 0;
  }

}
</style>
