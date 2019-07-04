<template>
<div class="event-detail__floating-buttons-container">
  <div class="floating-buttons__title-text">Can you come?</div>
  <ul class="event-detail__floating-buttons-list">
    <li class="event-detail__floating-button-item">
      <a @click="submitRsvpHandler" class="event-detail-floating-button w-inline-block">
        <div class="floating-button__black-text">Yes!</div>
      </a>
    </li>
    <li class="event-detail__floating-button-item">
      <router-link :to="{name:'DeclineRSVP', params:{eventId:event.id}}" class="event-detail-floating-button w-inline-block">
        <div class="floating-button__black-text">No</div>
      </router-link>
    </li>
  </ul>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import { rsvp } from '@/mixins'

export default {
  name: 'RsvpFooter',
  props: { event: { required: true } },
  mixins: [rsvp],
  computed: mapGetters(['currentUser']),
  methods: {
    async submitRsvpHandler () {
      if (this.event.participated) {
        this.$router.push({ name: 'CancelRSVP', params: { eventId: this.event.id } })
      } else if (this.currentUser.children.length === 1) {
        await this.submitRsvp(this.currentUser.children.map(c => c.id))
        this.$router.push({ name: 'Search' })
      } else {
        this.$router.push({ name: 'RsvpInfoCollection', params: { eventId: this.event.id } })
      }
    }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.event-detail__floating-buttons-container {
  position: fixed;
  left: 0%;
  top: auto;
  right: 0%;
  bottom: 0%;
  display: flex;
  width: 230px;
  margin: 0 auto 16px;
  padding: 24px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  border-radius: 4px;
  background-color: #1f88e9;
  box-shadow: 0 -1px 30px 0 rgba(0, 0, 0, 0.3);
  list-style-type: none;
}

.floating-buttons__title-text {
  color: #fff;
  font-size: 14px;
  line-height: 15.600000000000001px;
}

.event-detail__floating-buttons-list {
  display: flex;
  margin-top: 16px;
  margin-right: -8px;
  margin-bottom: 0;
  padding-left: 0;
  list-style-type: none;
}

.event-detail__floating-button-item {
  display: flex;
  margin: 0 8px 0 0;
  align-items: flex-end;
}

.event-detail-floating-button {
  display: flex;
  padding: 8px 24px;
  justify-content: flex-start;
  align-items: center;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, 0.03);
  border-radius: 4px;
  background-color: #f3f3f3;
  color: #fff;
}

.event-detail-floating-button:hover {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.event-detail-floating-button:active {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.floating-button__black-text {
  color: #000;
  font-size: 13px;
  text-align: center;
}

@media (max-width: 991px){
  .event-detail__floating-buttons-container {
    width: 230px;
  }

  .event-detail-floating-button:hover {
    background-image: linear-gradient(180deg, transparent, transparent);
  }

  .event-detail-floating-button:active {
    background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.03), rgba(0, 0, 0, 0.03));
  }

}

@media (max-width: 767px){
  .floating-button__black-text {
    font-size: 13px;
    line-height: 16px;
  }

}

@media (max-width: 479px){
  .event-detail__floating-buttons-container {
    padding: 16px 16px 20px;
  }

  .event-detail__floating-buttons-list {
    flex-direction: row;
  }

  .event-detail__floating-button-item {
    width: 100%;
    margin-top: 0;
  }

}
</style>
