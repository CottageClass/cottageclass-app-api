<template>
  <div>
    <DeleteEventConfirmationModal
      v-if="showDeleteConfirmationModal"
      v-on:closeModal="closeModal"
      :eventId="eventId"/>
    <MainNav />
    <LightBoxStyleWrapper>
      <LightBox
        v-if="images"
        ref="lightbox"
        :images="lightboxImages"
        :showLightBox="false"
      />
    </LightBoxStyleWrapper>
    <LoadingSpinner v-if="!event" />
    <div v-else class="event-detail__container w-container">
      <RSVPCard v-if="showRsvpCard"
                @rsvp-yes="goingClick"
                @rsvp-no="initiateDeclineRsvp"
                @wave="handleWave"
                :otherText="currentUser ? 'Say hi and suggest another time': null"
      />
      <div class="user-action-card__container">
        <div class="user-action-card__header">
          <div class="user-action-card__header__date">{{timeHeader}}</div>
          <div v-if="distance" class="user-action-card__header__distance">{{distance}}</div>
        </div>
        <div class="user-action-card__description">
          <div class="user-action-card__description-text">{{this.event.name}}</div>
        </div>
        <div class="user-action-card__footer">
          <div class="user-action-card__footer__user-summary">
            <router-link :to="{name:'UserPage', params:{id: event.hostId}}"
                         class="avatar-container">
              <AvatarImage className="user-action-card__photo"
                           :person="{facebookUid: event.hostFacebookUid, avatar: event.hostAvatar}"
                           imageSize="100"/>
              <div v-if="verified" class="badge-verified">
                <div class="unicode-character">✓</div>
                <div class="badge-text">Verified</div>
              </div>
            </router-link>
            <div class="user-action-card__user-info--container">
              <div class="user-action-card__user-info_list">
                <router-link :to="{name:'UserPage', params:{id: event.hostId}}"
                             class="user-action-card__user-info__name">
                  {{ userName }}</router-link>
                <div class="user-action-card__user-info__occupation truncate">{{occupation}}</div>
                <div class="user-action-card__user-info__kids truncate">{{kidsAges}}</div>
              </div>
            </div>
          </div>
          <div class="user-action-card__footer__actions">
            <SearchListCardActions
              class="column-list"
              :user="event.host"
              :event="event"
              @user-updated="updateUser"
              @interested-click="interestedClickWithPrompts('card')"
              @going-click="goingClick"
              @share-click="shareClick"
              :timePast="timePast"
              :showShareButton="showShareButton"
              :showInterestedButton="showInterestedButton"
              :showMeetButton="showMeetButton"
              :showGoingButton="showGoingButton"
              :allowWaveUndo="false"/>
          </div>
        </div>
      </div>
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
            <div class="household-photos__title-text">Household photos</div>
            <Images
              :images="images"
              @image-click="handleImageClick"
            />
          </div>
          <div class="event-detail__map map" ref="map"/>
          <div class="about-the-host__card">
            <div class="about-the-host__title-text">About the host</div>
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
            <router-link :to="{name: 'UserPage', params: {id: this.user.id}}" class="btn__more-about-host w-button">
              More about this host
            </router-link>
          </div>
          <div v-if="houseRules" class="house-rules__card">
            <div class="house-rulese_title-text">House Rules</div>
            <div class="card__description-and-icon-container w-clearfix"><img src="https://uploads-ssl.webflow.com/5c6c7d4a75c1e54694ed12d1/5c6c7d4a75c1e5183aed132e_house-rules.svg" width="100" height="100" alt="" class="house__image" />
              <div class="house-rules__text">{{houseRules}}</div>
            </div>
          </div>
          <div v-if="petDescription" class="pets__card">
            <div class="pets__title-text">Pets</div>
            <div class="card__description-and-icon-container w-clearfix">
              <img :src="petsImage" width="100" height="100" alt="" class="pets__image" />
              <div class="pets__text">{{petDescription}}</div>
            </div>
          </div>
        </div>
        <div v-if="otherEvents" class="event-detail__column-right w-col w-col-4 w-col-stack">
          <ul class="other-events__list">
            <li class="other-events__title-bar">
              <div class="other-events__title-text truncate">{{userFirstName}}'s offers</div>
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
import SearchListCardActions from '@/components/search/SearchListCardActions'
import AvatarImage from '@/components/base/AvatarImage'
import MainNav from '@/components/MainNav'
import Images from '@/components/Images'
import LoadingSpinner from '@/components/LoadingSpinner'
import Attendee from '@/components/Attendee'
import OtherEvent from '@/components/OtherEvent'
import LightBoxStyleWrapper from '@/components/LightBoxStyleWrapper'

import houseRulesImage from '@/assets/house-rules.svg'
import petsImage from '@/assets/pets.svg'

import { mapGetters } from 'vuex'
import { fetchUpcomingEvents, fetchEvent } from '@/utils/api'
import { item, maps, rsvp } from '@/mixins'
import DeleteEventConfirmationModal from '@/components/DeleteEventConfirmationModal.vue'

export default {
  name: 'EventPage',
  components: { MainNav, Images, LoadingSpinner, AvatarImage, SearchListCardActions, Attendee, OtherEvent, RSVPCard, LightBox, LightBoxStyleWrapper, DeleteEventConfirmationModal },
  mixins: [item, maps, rsvp],
  props: { showDeleteConfirmationModal: { default: false } },
  data () {
    return {
      eventId: this.$route.params.id,
      event: null,
      mapOptions: {
        'disableDefaultUI': true, // turns off map controls
        'gestureHandling': 'none' // prevents any kind of scrolling
      },
      otherEvents: null
    }
  },
  computed: {
    lightboxImages () {
      return this.images.map(i => {
        return {
          thumb: i,
          src: i
        }
      })
    },
    showRsvpCard () {
      if (!this.event || this.timePast) { return false }
      if (this.currentUser) {
        return (this.event.host.id.toString() !== this.currentUser.id.toString()) &&
               !this.event.participated &&
               !this.isRsvpDeclined(this.event.id)
      }
      return true
    },
    user () {
      return this.event && this.event.host
    },
    houseRulesImage: () => houseRulesImage,
    petsImage: () => petsImage,
    ...mapGetters(['isRsvpDeclined'])
  },
  methods: {
    closeModal () {
      this.$router.push({ path: 'EventPage' })
    },
    handleImageClick (payload) {
      this.debug('handle')
      this.$refs.lightbox.showImage(payload)
    },
    updateUser (user) {
      this.event.host = user
    },
    fetchEvent: async function () {
      try {
        this.event = await fetchEvent(this.$route.params.id)
      } catch (e) {
        this.logError(e)
        this.$router.push({ name: 'NotFound' })
      }
      this.otherEvents = (await fetchUpcomingEvents(this.event.hostId)).filter(e => (e.id !== this.$route.params.id))
      this.$nextTick(async function () {
        await this.createMap(this.$refs.map, {
          zoom: 13,
          center: { lat: this.event.hostFuzzyLatitude, lng: this.event.hostFuzzyLongitude },
          disableDefaultUI: true,
          options: this.mapOptions,
          style: 'width: 100px; height: 230px;'
        })
        await this.addCircle({ lat: this.event.hostFuzzyLatitude, lng: this.event.hostFuzzyLongitude }, 0.2)
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
    this.fetchEvent()
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

.badge-verified {
  position: absolute;
  left: 10px;
  top: auto;
  right: 10px;
  bottom: -8px;
  display: flex;
  min-height: 19px;
  min-width: 24px;
  justify-content: center;
  align-items: center;
  border-radius: 1000px;
  background-color: #0cba52;
  opacity: 0.92;
}
.avatar-container {
  position: relative;
}

.badge-text {
  margin-left: 4px;
  color: #fff;
  font-size: 8px;
  line-height: 12px;
  text-align: center;
  letter-spacing: .5px;
  text-transform: uppercase;
}

.unicode-character {
  color: #fff;
  font-size: 8px;
  line-height: 12px;
  text-align: center;
  letter-spacing: .5px;
  text-transform: uppercase;
}

.event-detail__container {
  margin-top: 32px;
  padding-right: 32px;
  padding-left: 32px;
}

.user-action-card__container {
  display: flex;
  width: 100%;
  margin-top: 0;
  padding: 24px 20px 33px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
}

.user-action-card__photo-wrapper {
  position: relative;
}

.user-action-card__header {
  position: relative;
  display: flex;
  min-height: 12px;
  margin-bottom: 12px;
  justify-content: flex-start;
  align-items: center;
}

.user-action-card__header__date {
  color: #1f88e9;
  font-size: 12px;
  line-height: 12px;
  text-transform: uppercase;
}

.user-action-card__header__distance {
  position: static;
  right: 0;
  margin-left: 8px;
  color: #64426b;
  font-size: 12px;
  line-height: 12px;
  text-transform: uppercase;
}

.user-action-card__description {
  display: flex;
  margin-bottom: 12px;
  justify-content: space-between;
  align-items: center;
}

.user-action-card__description-text {
  margin-top: 8px;
  margin-bottom: 16px;
  font-size: 16px;
  line-height: 22px;
}

.user-action-card__photo {
  position: static;
  max-height: 85px;
  max-width: 85px;
  min-height: 85px;
  min-width: 85px;
  margin: 0 1px 1px 0;
  border-radius: 4px;
}

.user-action-card__footer__user-summary {
  display: flex;
  align-items: center;
}

.user-action-card__footer {
  display: flex;
  justify-content: flex-start;
  flex-wrap: wrap;
  align-items: flex-end;
}

.user-action-card__footer__actions {
  display: flex;
  flex-direction: row;
}

.user-action-card__user-info--container {
  display: flex;
  margin-left: 12px;
  flex-direction: row;
  flex-wrap: wrap;
  align-items: center;
}

.user-action-card__user-info_list {
  margin-right: 20px;
  line-height: 20px;
}

.user-action-card__user-info__name {
  color: rgba(0, 0, 0, 0.86);
  font-size: 12px;
  line-height: 17px;
  font-weight: 700;
}

.user-action-card__user-info__name:hover {
  text-decoration: underline;
}

.user-action-card__user-info__occupation {
  overflow: hidden;
  width: 690px;
  color: rgba(0, 0, 0, 0.6);
  font-size: 12px;
  line-height: 17px;
}

.user-action-card__user-info__kids {
  overflow: hidden;
  width: 690px;
  color: rgba(0, 0, 0, 0.6);
  font-size: 12px;
  line-height: 17px;
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
  display: block;
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

.pets__card {
  position: static;
  display: flex;
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

.pets__title-text {
  margin-bottom: 16px;
  font-size: 16px;
  line-height: 24px;
}

.pets__text {
  font-size: 13px;
  line-height: 19px;
}

.house-rulese_title-text {
  margin-bottom: 16px;
  font-size: 16px;
  line-height: 24px;
}

.house-rules__text {
  display: block;
  width: auto;
  font-size: 13px;
  line-height: 19px;
}

.house-rules__card {
  position: static;
  display: flex;
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

.pets__image {
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

  .user-action-card__header {
    flex-direction: row;
    justify-content: flex-start;
  }

  .user-action-card__user-info__occupation {
    width: 480px;
  }

  .user-action-card__user-info__kids {
    width: 480px;
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
  .badge-text {
    margin-left: 0;
  }

  .unicode-character {
    display: none;
  }

  .event-detail__container {
    margin-top: 16px;
    padding-right: 0;
    padding-left: 0;
  }

  .user-action-card__container {
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .user-action-card__description-text {
    font-size: 13px;
    line-height: 19.5px;
  }

  .user-action-card__photo {
    max-height: 85px;
    max-width: 85px;
    min-height: 85px;
    min-width: 85px;
  }

  .user-action-card__user-info__occupation {
    width: 320px;
  }

  .user-action-card__user-info__kids {
    width: 320px;
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

  .pets__card {
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .pets__title-text {
    font-size: 14px;
    line-height: 18px;
  }

  .house-rulese_title-text {
    font-size: 14px;
    line-height: 18px;
  }

  .house-rules__card {
    min-height: 170px;
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .list {
    margin-bottom: 0;
  }
}

@media (max-width: 479px){
  .column-list {
    flex-direction: column;
    width:100%;
  }
  .badge-verified {
    left: 6px;
    right: 6px;
  }

  .user-action-card__footer__actions {
    width: 100%;
  }

  .user-action-card__user-info__occupation {
    width: 170px;
  }

  .user-action-card__user-info__kids {
    width: 170px;
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
