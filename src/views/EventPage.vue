<template>
  <div>
    <DeleteEventConfirmationModal
      v-if="showDeleteConfirmationModal"
      v-on:closeModal="closeModalClick"
      :eventId="eventId"/>
    <MainNav />
    <LightBoxStyleWrapper>
      <LightBox
        v-if="images"
        ref="lightbox"
        :images="lightboxImages"
        :showLightBox="false"
        v-on:onOpened="setLightBox($event)"
      />
    </LightBoxStyleWrapper>
    <LoadingSpinner v-if="!event" />
    <div v-else class="event-detail__container w-container">
      <RSVPCard v-if="showRsvpCard"
                @rsvp-yes="goingClick"
                @rsvp-no="initiateDeclineRsvp"
                :otherText="currentUser ? 'Say hi and suggest another time': null"
      />

      <EventSearchListCard
        :item="{user: event.user, event: event}"
        :distanceCenter="mapArea.center"
        @interested-click="interestedClickAndUpdate('card')"
        @contact-click="contactClick"
        @event-updated="updateEvent"
        @going-click="goingClick"
        @user-updated="updateUser"
      />

      <div class="event-detail__content-columns w-row">
        <div class="event-detail__column-left w-col w-col-8 w-col-stack">
          <div v-if="event.participatingParents && event.participatingParents.length" class="attendees__card">
            <div class="attendees__title-text">Going ({{event.participatingParents.length}})</div>
            <ul class="list">
              <Attendee
                v-for="attendee of event.participatingParents"
                :key="'attendee' + attendee.userId"
                :user="attendee" />
            </ul>
          </div>
          <div v-if="images && images.length>0" class="household-photos__card">
            <div class="household-photos__title-text">Photos</div>
            <Images
              :images="images"
              :size="350"
              @image-click="handleImageClick"
            />
          </div>
          <div class="event-detail__map map" ref="map"/>
          <div class="about-the-host__card">
            <div class="about-the-host__title-text">Suggested by {{userFirstName}}</div>
            <div class="about-the-host__info"></div>
            <ul class="protile-top-card__about-llist">
              <li v-if="verified" class="about-the-host__list-item" >
                <div class="bullet-bar"><img src="@/assets/check-white.svg" alt="" class="image-2"></div>
                <div class="about-the-host__bullet-text">Verified</div>
              </li>
              <li v-if="occupation" class="about-the-host__list-item">
                <div class="bullet-bar"><img src="@/assets/check-white.svg" alt="" class="image-2"></div>
                <div class="about-the-host__bullet-text">{{occupation}}</div>
              </li>
              <li v-if="languageText" class="about-the-host__list-item">
                <div class="bullet-bar"><img src="@/assets/check-white.svg" alt="" class="image-2"></div>
                <div class="about-the-host__bullet-text">{{languageText}}</div>
              </li>
              <li class="about-the-host__list-item">
                <div class="bullet-bar"><img src="@/assets/check-white.svg" alt="" class="image-2"></div>
                <div class="about-the-host__bullet-text">Member since {{ joinedDateFormatted }}</div>
              </li>
            </ul>
            <div v-if="profileBlurb" class="about-the-host__bio">
              <div class="about-the-host__bio-text">{{profileBlurb}}</div>
            </div>
            <div class="more-about-buttons">
              <router-link :to="{name: 'UserPage', params: {id: this.user.id}}" class="btn__more-about-host w-button">
                More about this host
              </router-link>
              <router-link v-if="this.place.public === true" :to="{name: 'PlacePage', params: {id: this.place.id}}" class="btn__more-about-host w-button">
                More about this place
              </router-link>
            </div>
          </div>
        </div>
        <div v-if="otherEvents" class="event-detail__column-right w-col w-col-4 w-col-stack">
          <ul class="other-events__list">
            <li class="other-events__title-bar">
              <div class="other-events__title-text truncate"
                   v-html="otherEventsColumnTitle"></div>
            </li>
            <OtherEvent v-for="otherEvent of otherEvents"
                        :key="otherEvent.id"
                        :event="otherEvent"
                        @item-click="$router.push({ name: 'EventPage', params: { id: otherEvent.id } })"
                        class="other-events__title-bar"/>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import LightBox from 'vue-image-lightbox'
import RSVPCard from '@/components/base/RSVPCard'
import MainNav from '@/components/MainNav'
import Images from '@/components/Images'
import LoadingSpinner from '@/components/LoadingSpinner'
import Attendee from '@/components/Attendee'
import OtherEvent from '@/components/OtherEvent'
import LightBoxStyleWrapper from '@/components/LightBoxStyleWrapper'
import DeleteEventConfirmationModal from '@/components/DeleteEventConfirmationModal.vue'
import EventSearchListCard from '@/components/search/EventSearchListCard'

import { mapGetters } from 'vuex'
import { fetchEventsByPlace, fetchEvent } from '@/utils/api'
import { item, maps, rsvp, lightbox } from '@/mixins'
import { lightboxImageUrl } from '@/utils/vendor/cloudinary'

export default {
  name: 'EventPage',
  components: { MainNav, Images, LoadingSpinner, Attendee, OtherEvent, RSVPCard, LightBox, LightBoxStyleWrapper, DeleteEventConfirmationModal, EventSearchListCard },
  mixins: [item, maps, rsvp, lightbox],
  props: { showDeleteConfirmationModal: { default: false } },
  data () {
    return {
      eventId: this.$route.params.id,
      event: null,
      mapOptions: {
        'disableDefaultUI': true, // turns off map controls
        'gestureHandling': 'none' // prevents any kind of scrolling
      },
      showLightBox: false,
      otherEvents: null
    }
  },
  computed: {
    otherEventsColumnTitle () {
      if (this.event.place.public) {
        return `Other events at ${this.event.place.name}`
      } else {
        return `Other events at ${this.user.firstName}'s home`
      }
    },
    mapCenter () {
      return {
        lat: this.place.latitude || this.place.fuzzyLatitude,
        lng: this.place.longitude || this.place.fuzzyLongitude
      }
    },
    distanceCenter () {
      if (!this.currentUser) { return null }
      const place = this.currentUser.place
      return {
        lat: place.latitude || place.fuzzyLatitude,
        lng: place.longitude || place.fuzzyLongitude
      }
    },
    lightboxImages () {
      const transformedImages = this.images.map(url => lightboxImageUrl(url))
      return transformedImages.map(i => {
        return {
          thumb: i,
          src: i
        }
      })
    },
    showRsvpCard () {
      if (!this.event || this.timePast || this.showLightBox) { return false }
      if (this.currentUser) {
        return (this.event.user.id.toString() !== this.currentUser.id.toString()) &&
               !this.event.participated &&
               !this.isRsvpDeclined(this.event.id)
      }
      return true
    },
    user () {
      return this.event && this.event.user
    },
    ...mapGetters(['isRsvpDeclined', 'items', 'mapArea'])
  },
  methods: {
    updateEvent (e) {
      this.event = e.event
      this.$store.commit('updateEvent', { event: this.event })
    },
    async interestedClickAndUpdate () {
      this.event.user = await this.interestedClick()
    },
    closeModalClick () {
      this.$router.push({ name: 'EventPage', params: { id: 5, showDeleteConfirmationModal: false } })
    },
    handleImageClick (payload) {
      this.debug('handle')
      this.$refs.lightbox.showImage(payload)
    },
    updateUser (payload) {
      this.event.user = payload.user
    },
    fetchEvent: async function (id = this.$route.params.id) {
      try {
        this.event = await fetchEvent(id)
      } catch (e) {
        this.logError(e)
        this.$router.push({ name: 'NotFound' })
      }
      this.otherEvents = (await fetchEventsByPlace(this.event.place.id)).filter(e => (e.id !== this.$route.params.id))
      this.$nextTick(async function () {
        await this.createMap(this.$refs.map, {
          zoom: 13,
          center: this.mapCenter,
          disableDefaultUI: true,
          options: this.mapOptions,
          style: 'width: 100px; height: 230px;'
        })
        if (this.event.place.latitude && this.event.place.longitude) {
          this.addLilypadPin(this.mapCenter)
        } else {
          await this.addCircle(this.mapCenter, 0.2)
        }
      })
    }
  },
  async created () {
    await this.fetchEvent()
    if (this.$route.query && this.$route.query.interested) {
      if (this.$route.query.interested === 'yes') {
        this.goingClick()
      } else if (this.$route.query.interested === 'no') {
        this.initiateDeclineRsvp()
      }
    }
  },
  beforeRouteUpdate (to, from, next) {
    this.fetchEvent(to.params.id)
    next()
  }
}
</script>

<style scoped lang="scss">

a {
  color: #000;
  text-decoration: none;
}

.image-2 {
  width: 12px;
  height: 12px;
  line-height: 1px;
}

.event-detail__map {
  position: relative;
  display: flex;
  width: 100%;
  min-height: 240px;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  background-color: #fff;
  background-position: 50% 50%;
  background-size: 900px;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
}

.event-detail__container {
  margin-top: 32px;
  padding-right: 32px;
  padding-left: 32px;
}

.event-detail__column-right {
  padding-left: 8px;
}

.event-detail__content-columns {
  margin-top: 16px;
  padding-bottom: 140px;
}

.event-detail__column-left {
  padding-right: 8px;
}

.other-events__title-bar {
  display: flex;
  width: 100%;
  margin-top: 0;
  padding: 16px 20px 18px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.other-events__title-text {
  overflow: hidden;
  width: 220px;
  font-size: 16px;
  line-height: 24px;
}

.other-events__list {
  margin-bottom: 0;
  padding-left: 0;
}

.other-events__view-more {
  position: relative;
  display: flex;
  width: 100%;
  margin-top: 0;
  padding: 0;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.household-photos__title-text {
  font-size: 16px;
  line-height: 24px;
}

.household-photos__card {
  position: relative;
  display: flex;
  width: 100%;
  min-height: 201px;
  margin-top: 0;
  margin-bottom: 16px;
  padding: 16px 20px 18px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.about-the-host__card {
  position: relative;
  display: flex;
  min-height: 140px;
  margin-top: 16px;
  margin-bottom: 16px;
  padding: 16px 20px 20px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.about-the-host__title-text {
  margin-bottom: 16px;
  font-size: 16px;
  line-height: 24px;
}

.bullet-bar {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  height: 16px;
  min-width: 16px;
  margin-top: 2px;
  clear: left;
  -webkit-box-pack: center;
  -webkit-justify-content: center;
  -ms-flex-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
  border-radius: 50%;
  background-color: #8fd8e9;
}

.about-the-host__info {
  position: static;
  display: flex;
  width: 100%;
  justify-content: space-between;
  align-items: center;
}

.protile-top-card__about-llist {
  margin-top: 0px;
  margin-bottom: 11px;
  padding-left: 0px;
  list-style-type: none;
}

.about-the-host__list-item {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  min-height: 26px;
  margin-bottom: 8px;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
}

.about-the-host__bullet-text {
  display: flex;
  max-width: 530px;
  margin-left: 10px;
  align-items: center;
  font-size: 13px;
  line-height: 17px;
}

.about-the-host__bio {
  margin-bottom: 16px;
}

.about-the-host__bio-text {
  font-size: 13px;
  line-height: 19px;
}

.btn__more-about-host {
  display: inline-block;
  margin-right: 10px;
  padding: 4px 16px 5px;
  border: 1px solid transparent;
  border-radius: 4px;
  background-color: #1f88e9;
  color: #fff;
  font-size: 12px;
  font-weight: 400;
}

.btn__more-about-host:hover {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.other-events__view-more-link {
  position: relative;
  padding: 16px 20px;
  color: #1f88e9;
  font-size: 13px;
  line-height: 15.6px;
}

.other-events__view-more-link:hover {
  background-color: rgba(0, 0, 0, 0.03);
}

.attendees__card {
  display: flex;
  width: 100%;
  margin-top: 0;
  margin-bottom: 0;
  padding: 16px 20px 20px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.attendees__title-text {
  margin-bottom: 16px;
  font-size: 16px;
  line-height: 24px;
}

.card__description-and-icon-container {
  position: relative;
  width: 100%;
}

.house__image {
  position: static;
  left: auto;
  top: 16px;
  right: 16px;
  bottom: auto;
  width: 60px;
  height: 60px;
  margin-top: -37px;
  margin-bottom: 10px;
  margin-left: 10px;
  float: right;
}

.list {
  display: flex;
  width: auto;
  margin: -8px -8px -16px;
  padding-right: 0;
  padding-left: 0;
  flex-wrap: wrap;
  align-items: flex-start;
}

@media (max-width: 991px){
  .event-detail__map {
    max-height: 210px;
  }

  .event-detail__column-right {
    padding-left: 10px;
  }

  .event-detail__content-columns {
    margin-top: 16px;
  }

  .event-detail__column-left {
    margin-bottom: 0;
    padding-right: 10px;
  }

  .other-events__title-text {
    width: 600px;
  }

  .protile-top-card__about-llist {
    max-width: 340px;
  }

  .other-events__view-more-link:hover {
    background-color: transparent;
  }

  .other-events__view-more-link:active {
    background-color: rgba(0, 0, 0, 0.03);
  }
}

@media (max-width: 767px){

  .event-detail__container {
    margin-top: 16px;
    padding-right: 0;
    padding-left: 0;
  }

  .event-detail__column-right {
    padding-right: 0;
    padding-left: 0;
  }

  .event-detail__column-left {
    padding-right: 0;
    padding-left: 0;
  }

  .other-events__title-bar {
    padding: 16px;
    border-radius: 0;
  }

  .other-events__title-text {
    width: 430px;
    font-size: 14px;
    line-height: 18px;
  }

  .other-events__view-more {
    border-radius: 0;
  }

  .household-photos__title-text {
    font-size: 14px;
    line-height: 18px;
  }

  .household-photos__card {
    min-height: 186px;
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .about-the-host__card {
    min-height: 170px;
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .about-the-host__title-text {
    font-size: 14px;
    line-height: 18px;
  }

  .about-the-host__info {
    align-items: flex-start;
  }

  .protile-top-card__about-llist {
    max-width: 365px;
    -webkit-box-align: start;
    -webkit-align-items: flex-start;
    -ms-flex-align: start;
    align-items: flex-start;
  }

  .attendees__card {
    padding: 16px 16px 0;
    border-radius: 0;
  }

  .attendees__title-text {
    font-size: 14px;
    line-height: 18px;
  }

  .list {
    margin-bottom: 0;
  }

}

@media (max-width: 479px){
  .more-about-buttons {
     margin-bottom: -20px
  }
  .btn__more-about-host {
     margin-bottom: 20px
  }
  .column-list {
    flex-direction: column;
    width:100%;
  }

  .other-events__title-text {
    width: 270px;
  }

  .about-the-host__info {
    flex-direction: column;
    align-items: center;
  }

  .protile-top-card__about-llist {
    max-width: 288px;
  }

  .about-the-host__list-item {
    line-height: 20px;
  }

  .list {
    margin-right: 0;
  }

}
</style>
