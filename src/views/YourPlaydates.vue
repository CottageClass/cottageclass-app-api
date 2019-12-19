<template>
  <div class="body__your-playdates">
    <MainNav />

    <div class="your-playdates__container w-container">
      <ListSection title="Interested"
                   :emptyOptions="interestedEmptyOptions"
                   :items="interestedItems"
                   @empty-card-button-click="goHome()"
      />
      <ListSection title="Going"
                   :emptyOptions="goingEmptyOptions"
                   :items="goingItems"
                   @empty-card-button-click="goHome()"
      />
      <ListSection title="Offers"
                   buttonText="Offer Playdate"
                   :emptyOptions="yourOffersEmptyOptions"
                   :items="yourOffersItems"
                   @header-button-click="$router.push({ name: 'NewEvent' })"
                   @empty-card-button-click="$router.push({ name: 'NewEvent' })"
                   @empty-card-additional-link-click="goHome()"
      />
      <ListSection title="Availability"
                   buttonText="Edit"
                   @header-button-click="goToAvailability"
      >
        <li v-if="availableTimes" class="card" >
          <div  class="availability__card">
            <div class="card__description-and-icon-container w-clearfix">
              <div class="availability__tag-container">
                <div v-for="time of availableTimes" class="tag">
                  <div class="tag-text2">{{ time }}</div>
                </div>
              </div>
            </div>
          </div>
        </li>
        <ListSectionEmptyCard v-else
                              @button-click="goToAvailability"
                              :options="availabilityEmptyOptions"/>
      </ListSection>
    </div>
    <Footer />
  </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex'

import ListSection from '@/components/ListSection'
import MainNav from '@/components/MainNav.vue'
import Footer from '@/components/Footer.vue'
import ListSectionEmptyCard from '@/components/ListSectionEmptyCard'

import heartDoor2 from '@/assets/heart-door-2.svg'
import playdates2 from '@/assets/playdates-2.svg'
import availability2 from '@/assets/availability-2.svg'

import { item, redirect, goHome } from '@/mixins'
import { fetchUpcomingParticipatingEvents, fetchUpcomingEvents, fetchStarredEvents } from '@/utils/api'

export default {
  name: 'YourPlaydates',
  components: { ListSection, MainNav, Footer, ListSectionEmptyCard },
  mixins: [ item, redirect, goHome ],
  data () {
    return {
      goingItems: null,
      interestedItems: null,
      yourOffersItems: null
    }
  },
  computed: {
    user () {
      return this.currentUser
    },
    availabilityEmptyOptions () {
      return {
        title: 'You haven\'t chosen any availability yet. Can you tell us when you\'re usually free?',
        buttonText: 'Edit Availability'
      }
    },
    interestedEmptyOptions () {
      return {
        image: heartDoor2,
        title: 'You haven\'t starred any playdates yet',
        buttonText: 'Find playdates near you'
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
        title: 'You haven\'t suggested any playdates yet.',
        buttonText: 'Offer some playdates',
        additionalLinkText: 'Find playdates near you'
      }
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    goToAvailability () {
      this.$router.push({ name: 'ProfileEdit', hash: '#availability' })
    },
    async fetchAll () {
      await this.fetchGoing()
      await this.fetchInterestedEvents()
      await this.fetchMyEvents()
    },
    async fetchGoing () {
      this.goingItems = await fetchUpcomingParticipatingEvents(this.currentUser.id)
    },
    async fetchInterestedEvents () {
      this.interestedItems = await fetchStarredEvents(this.currentUser.id)
    },
    async fetchMyEvents () {
      const allMyEvents = await fetchUpcomingEvents(this.currentUser.id, e => e.starts_at)
      this.debug({ allMyEvents })
      this.yourOffersItems = allMyEvents.map(e => ({ event: e, user: e.user }))
    },
    ...mapMutations(['updateEventSeries'])
  },
  created () {
    if (this.redirectToSignupIfNotAuthenticated()) { return }
    this.fetchAll()
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
