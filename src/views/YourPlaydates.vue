<template>
<div class="body__your-playdates">
  <MainNav />

  <div class="your-playdates__container w-container">
    <ListSection title="Hosting"
                 :emptyOptions="hostingEmptyOptions"
                 :items="hostingItems"
                 @event-updated="fetchMyEvents"
                 />
    <ListSection title="Going"
                 :emptyOptions="goingEmptyOptions"
                 :items="goingItems"
                 @event-updated="fetchGoing"
                 />
    <ListSection title="Your offers"
                 buttonText="Offer Playdate"
                 :emptyOptions="yourOffersEmptyOptions"
                 :items="yourOffersItems"
                 @header-button-click="$router.push({ name: 'NewEvent' })"
                 @event-updated="fetchMyEvents"
                 />
    <ListSection title="Availability"
                 buttonText="Edit"
                 @header-button-click="$router.push({name: 'ProfileEdit'})"
                 >
      <div v-if="availableTimes" class="availability__card">
        <div class="card__description-and-icon-container w-clearfix">
          <div class="availability__tag-container">
            <div v-for="time of availableTimes" class="tag">
              <div class="tag-text2">{{ time }}</div>
            </div>
          </div>
        </div>
      </div>
    </ListSection>
  </div>
  <Footer />
</div>
</template>

<script>
import { mapGetters } from 'vuex'

import ListSection from '@/components/ListSection'
import MainNav from '@/components/MainNav.vue'
import Footer from '@/components/Footer.vue'

import heartDoor2 from '@/assets/heart-door-2.svg'
import playdates2 from '@/assets/playdates-2.svg'
import availability2 from '@/assets/availability-2.svg'

import { item } from '@/mixins'
import { fetchUpcomingParticipatingEvents, fetchUpcomingEvents } from '@/utils/api'

export default {
  name: 'YourPlaydates',
  components: { ListSection, MainNav, Footer },
  mixins: [ item ],
  data () {
    return {
      goingItems: null,
      hostingItems: null,
      yourOffersItems: null
    }
  },
  computed: {
    user () {
      return this.currentUser
    },
    hostingEmptyOptions () {
      return {
        image: heartDoor2,
        title: 'You don\'t have any playdates scheduled',
        buttonText: 'Offer Playdate',
        additionalLinkText: 'Find playdates near you'
      }
    },
    goingEmptyOptions () {
      return {
        image: playdates2,
        title: 'You aren\'t currently going to any playdates.',
        buttonText: 'Find playdates near you'
      }
    },
    yourOffersEmptyOptions () {
      return {
        image: availability2,
        title: 'You aren\'t currently offering any playdates.',
        buttonText: 'Update your availability',
        additionalLinkText: 'Find playdates near you'
      }
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    async fetchGoing () {
      this.goingItems = await fetchUpcomingParticipatingEvents(this.currentUser.id)
    },
    async fetchMyEvents () {
      const allMyEvents = await fetchUpcomingEvents(this.currentUser.id, e => e.starts_at)
      this.debug({ allMyEvents })
      this.hostingItems = allMyEvents.filter(i => i.participatingParents.length > 0).map(e => ({ event: e, user: e.host }))
      this.yourOffersItems = allMyEvents.filter(i => i.participatingParents.length === 0).map(e => ({ event: e, user: e.host }))
    }
  },
  created () {
    this.fetchGoing()
    this.fetchMyEvents()
  }
}
</script>

<style scoped lang="scss">
body {
  font-family: soleil, sans-serif;
  color: #333;
  font-size: 14px;
  line-height: 20px;
}

.body__your-playdates {
  background-color: #f6f6f6;
}

.your-playdates__container {
  margin-top: 32px;
  margin-bottom: 200px;
  padding-right: 32px;
  padding-left: 32px;
}

.tag {
  display: inline-block;
  margin-right: 10px;
  margin-bottom: 12px;
  padding: 9px 15px 12px;
  clear: none;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, 0.11);
  border-radius: 20px;
  background-color: transparent;
}
.tag-text2 {
  margin-top: 1px;
  color: #333;
  font-size: 14px;
  line-height: 9px;
  font-weight: 400;
  text-transform: none;
}
.availability__tag-container {
  display: block;
  width: 100%;
  margin-top: 16px;
  align-items: flex-start;
  text-align: left;
}

@media (max-width: 767px){
  .your-playdates__container {
    padding-right: 0;
    padding-left: 0;
  }
  .tag {
    margin-right: 8px;
    margin-bottom: 10px;
    padding: 8px 14px 10px;
  }

  .tag-text2 {
    font-size: 13px;
  }
}
</style>
