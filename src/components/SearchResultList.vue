<template>
  <div class="list-wrapper">
    <LoadingSpinner v-if="awaiting"/>
    <div class="user-list" v-if="!awaiting">
      <div v-for="(user, index) in users">
        <SearchListCard
          :user="user"
          :mapCenter="mapArea.center"
          :key="index"
        />
      </div>
    </div>
    <div v-if="showFetchMoreUsersButton && !awaiting"
          class="user-pagination-button"
          @click="$emit('fetchMoreUsersClick')">
          Show more
    </div>

    <div class="event-list" v-if="!awaiting">
      <div v-for="(event, index) in events">
        <div
            v-if="showDates && (index === 0 || (formatDate(event.startsAt) !== formatDate(events[index - 1].startsAt)))"
            class="event-date-section-tittle">
          <img src="@/assets/date-outline-white-oval.svg" alt="" class="image-264">
          <div class="date-text-wrapper">
            <div class="date-title">
              <span v-if="isToday(event.startsAt)">
                <strong class="bold-text">Today</strong>,
              </span>
              {{ formatDate(event.startsAt) }}
            </div>
          </div>
        </div>
        <EventListItem
          :event="event"
          :index="index"
          :key="index"
          :showRsvpButton="currentUser === null || currentUser.id !== event.hostId"
          :showEditButton="isAuthenticated && currentUser.id === event.hostId"
          :distance="distanceFromCurrentUser(event.hostFuzzyLatitude,
                                            event.hostFuzzyLongitude)"
        />
      </div>
    </div>
    <div v-if="showFetchMoreEventsButton && !awaiting"
          class="event-pagination-button"
          @click="$emit('fetchMoreEventsClick')">
          Show more
    </div>

    <!-- in the case of no events -->
    <div v-if="noEvents && showTrailblazerMessage">
      <TrailblazerCard />
    </div>
    <p v-if="noEvents && !showTrailblazerMessage"
       class="no-events-message"
       v-html="noEventsMessage">
    </p>
  </div>
</template>

<script>
import TrailblazerCard from '@/components/TrailblazerCard.vue'
import EventListItem from '@/components/EventListItem.vue'
import SearchListCard from '@/components/search/SearchListCard'
import LoadingSpinner from '@/components/LoadingSpinner.vue'
import { mapGetters } from 'vuex'

var moment = require('moment')
export default {
  name: 'SearchResultList',
  components: { EventListItem, LoadingSpinner, SearchListCard, TrailblazerCard },

  props: {
    noEventsMessage: {},
    events: { links: null },
    users: { links: null },
    showDates: {
      type: Boolean,
      default: true
    },
    showTrailblazerMessage: {
      type: Boolean,
      default: false
    },
    showFetchMoreEventsButton: {
      type: Boolean,
      requred: true
    },
    showFetchMoreUsersButton: {
      type: Boolean,
      requred: true
    }
  },
  methods: {
    formatDate: function (date) {
      return moment(date).format('dddd, MMM Do')
    },
    isToday: function (date) {
      return moment(0, 'HH').diff(date, 'days') === 0
    }
  },
  computed: {
    awaiting: function () {
      return this.events === null || this.users === null
    },
    noEvents: function () {
      return this.events !== null && this.events.length === 0
    },
    ...mapGetters(['currentUser', 'distanceFromCurrentUser', 'isAuthenticated', 'mapArea'])
  }
}
</script>

<style lang="scss" scoped>
select {
  appearance: menulist;
  --webkit-appearance: menulist;
}

.user-pagination-button {
  cursor: pointer;
  &:hover {
    background-color: #00000006;
  }
  display: flex;
  width: 100%;
  margin-top: 0px;
  padding: 20px;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
  color: hsla(208.8118811881188, 82.11%, 51.76%, 1.00);
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, .08);
}

.event-pagination-button {
  width: 200px;
  margin-left: auto;
  margin-right: auto;
  padding: 12px 32px;
  border-radius: 4px;
  background-color: #1f88e9;
  text-align: center;
  -webkit-text-fill-color: #fff;  // DO NOT REMOVE.  REQUIRED FOR SAFARI
  color: #fff;
}
.body {
  all: unset;
  font-family: soleil, sans-serif;
  color: #333;
  font-size: 14px;
  line-height: 20px;
  background-color: #fff;
}

a {
  color: #000;
  text-decoration: none;
}

.body {
  overflow: visible;
  background-color: #fff;
  font-family: soleil, sans-serif;
}

.content-section {
  display: block;
  margin-top: 0px;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
  background-color: #fff;
}

.content-section.background-01 {
  background-color: #f6f6f6;
}

.divider-2px {
  width: 100%;
  height: 2px;
  background-color: #f3f3f3;
}

.content-container-2 {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  margin-top: 0px;
  margin-bottom: 0px;
  padding: 112px 32px;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -webkit-flex-direction: column;
  -ms-flex-direction: column;
  flex-direction: column;
  -webkit-box-pack: start;
  -webkit-justify-content: flex-start;
  -ms-flex-pack: start;
  justify-content: flex-start;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
}

.link {
  text-decoration: none;
}

.link:hover {
  text-decoration: underline;
}

.list-wrapper {
  display: flex;
  flex-direction: column;
  width: 100%;
}

.list-wrapper div:first-child .event-date-section-tittle {
  margin-top: 0px
}

.event-date-section-tittle {
  display: flex;
  margin-top: 68px;
  margin-bottom: 16px;
  padding: 16px 16px 16px 0px;
  justify-content: flex-start;
  align-items: center;
  border-radius: 4px;
}

.date-title {
  font-size: 24px;
  line-height: 28px;
  text-align: center;
}

.bold-text {
  color: #ff6550;
}

.more-link {
  color: #1f88e9;
  font-size: 20px;
  text-align: center;
  text-decoration: none;
}

.body-2 {
  background-color: #f6f6f6;
}

.content-container-3 {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  margin-top: 0px;
  margin-bottom: 0px;
  padding: 112px 32px;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -webkit-flex-direction: column;
  -ms-flex-direction: column;
  flex-direction: column;
  -webkit-box-pack: start;
  -webkit-justify-content: flex-start;
  -ms-flex-pack: start;
  justify-content: flex-start;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
}

.content-container-4 {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  margin-top: 0px;
  margin-bottom: 0px;
  padding: 32px 32px 112px;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -webkit-flex-direction: column;
  -ms-flex-direction: column;
  flex-direction: column;
  -webkit-box-pack: start;
  -webkit-justify-content: flex-start;
  -ms-flex-pack: start;
  justify-content: flex-start;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
}

.date-text-wrapper {
  padding-left: 16px;
}

.event-date-section-more-events {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  margin-bottom: 16px;
  padding: 16px 16px 16px 0px;
  -webkit-box-pack: center;
  -webkit-justify-content: center;
  -ms-flex-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
  border-radius: 4px;
}

.image-264 {
  width: 40px;
  background-color: #fff;
}
.no-events-message {
  margin-top: 100px;
}

@media (max-width: 991px) {
  .content-container-2 {
    padding-top: 100px;
    padding-bottom: 128px;
  }

  .content-container-3 {
    padding-top: 100px;
    padding-bottom: 128px;
  }

  .content-container-4 {
    padding-bottom: 128px;
  }

  .no-events-message {
    margin: 50px 10px 0;
  }
}

@media (max-width: 767px) {
  .user-pagination-button {
    padding: 16px;
    justify-content: center;
    border-radius: 0px;
  }

  .body {
    padding-bottom: 100px;
  }

  .content-container-2 {
    padding-right: 32px;
    padding-bottom: 100px;
    padding-left: 32px;
  }

  .date-title {
    font-size: 22px;
    line-height: 26px;
  }

  .content-container-3 {
    padding-right: 32px;
    padding-bottom: 100px;
    padding-left: 32px;
  }

  .content-container-4 {
    padding-right: 32px;
    padding-bottom: 100px;
    padding-left: 32px;
  }
}

@media (max-width: 479px) {
  .body {
    padding-bottom: 110px;
  }

  .event-date-section-tittle {
    margin-top: 52px;
  }

  .content-container-2 {
    padding-top: 64px;
    padding-bottom: 64px;
  }

  .date-title {
    font-size: 18px;
    line-height: 24px;
    text-align: left;
  }

  .content-container-3 {
    padding: 64px 16px;
  }

  .content-container-4 {
    padding: 64px 16px;
  }

  .image-264 {
    width: 32px;
  }
}
</style>
