<template>
  <div>
    <MainNav />
    <LightBoxStyleWrapper>
      <LightBox
        v-if="images"
        ref="lightbox"
        :images="lightboxImages"
        :showLightBox="false"
      />
      </LightBoxStyleWrapper>
    <LoadingSpinner v-if="!user" />
    <div class="profile__container w-container" v-else>
      <div class="profile-top-card__container">
        <div class="profile__user-basics-container">
          <div class="profile-top-card__photo-wrapper">
            <AvatarImage className="profile-top-card__photo"
                         :person="user"
                         imageSize="200"/>
            <div v-if="verified" class="profile-top-card__badge-verified">
              <div class="profile__badge__check-mark">✓</div>
              <div class="profile__badge-text">Verified</div>
            </div>
          </div>
          <div class="profile-top-card__user-summary-info">
            <div class="profile-top-card__name-action-group">
              <h1 class="profile-top-card__user-name">{{userName}}</h1>
              <a v-if="showInterestedButton" class="profile-top-card__action-button w-inline-block"
                  :class="isStarred?'active':''"
                  @click.stop="interestedClickAndUpdate"></a>
              <div v-if="distance" class="profile-top-card__distance">{{ distance }}</div>
            </div>
            <div class="profile-top-card__occupation">{{ occupation }}</div>
            <div class="profile-top-card__ages">{{ kidsAges }}</div>
            <div v-if="profileBlurb" class="about__description">
              <div class="bio__triangle"></div>
              <div class="about-host__bio-text">{{ profileBlurb }}</div>
              <div class="bio__talk-bubble-caret--right"></div>
              <div class="bio__talk-bubble-caret--top"></div>
            </div>
            <ul class="protile-top-card__about-llist">
              <li v-if="languageText" class="about-the-host__list-item">
                <div class="bullet-bar"></div>
                <div class="about-the-host__bullet-text">{{ languageText }}</div>
              </li>
              <li class="about-the-host__list-item">
                <div class="bullet-bar"></div>
                <div class="about-the-host__bullet-text">Member since {{ joinedDateFormatted }}</div>
              </li>
              <li v-if="verified" class="about-the-host__list-item">
                <div class="bullet-bar"></div>
                <div class="about-the-host__bullet-text">Verified social media account</div>
              </li>
            </ul>
          </div>
        </div>
        <SearchListCardActions
                        class="profile-top-card__footer__button-list"
                        :user="user"
                        @user-updated="updateUser"
                        @interested-click="interestedClickWithPrompts"
                        :showInterestedButton="showInterestedButton"
                        :showMeetButton="showMeetButton"
                        :showGoingButton="showGoingButton"
                        :allowWaveUndo="false"/>

      </div>
      <div class="profile-detail__content-columns w-row">
        <div class="profile-detail_column-left w-col w-col-8 w-col-stack">
          <div v-if="interests" class="interests__card">
            <div class="interests__title-text">Interests</div>
            <div class="card__description-and-icon-container w-clearfix">
              <img src="@/assets/interests.svg" width="100" height="100" alt="" class="interests_image" />
              <div class="interests__tag-container">
                <div v-for="interest in interests" class="tag">
                  <div class="tag-text2">{{ interest }}</div>
                </div>
              </div>
            </div>
          </div>
          <div v-if="availableTimes" class="availability__card">
            <div class="availability__title-text">Availability</div>
            <div class="card__description-and-icon-container w-clearfix">
              <img src="@/assets/time.svg" width="100" height="100" alt="" class="availability_image" />
              <div class="availability__tag-container">
                <div v-for="time of availableTimes" class="tag">
                  <div class="tag-text2">{{ time }}</div>
                </div>
              </div>
            </div>
          </div>
          <div v-if="images && images.length>0" class="household-photos__card">
            <div class="household-photos__title-text">Household photos</div>
              <Images
                 :images="images"
                 @image-click="handleImageClick"
               />
          </div>
          <div v-if="false" class="attended__card">
            <div class="attended__title-text">Parents who hosted {{ userFirstName }} (12)</div>
            <ul class="list">
              <li class="attendee__list-item"><a href="#" class="attendee__link-wrapper w-inline-block"><img src="@/assets/rima.png" alt="" class="attendee__photo photo-fit" />
                  <div class="attendee__user-name truncate">Barbara</div>
                </a></li>
            </ul>
          </div>
          <div v-if="false" class="hosted__card">
            <div class="attended__title-text">Parents hosted by {{ userFirstName }} (5)</div>
            <ul class="list">
              <li class="attendee__list-item"><a href="#" class="attendee__link-wrapper w-inline-block"><img src="@/assets/rima.png" alt="" class="attendee__photo photo-fit" />
                  <div class="attendee__user-name truncate">Charolotte</div>
                </a></li>
            </ul>
          </div>
          <div class="event-detail__map map" ref="map"></div>
          <div v-if="houseRules" class="house-rules__card">
            <div class="house-rulese_title-text">House Rules</div>
            <div class="card__description-and-icon-container w-clearfix">
              <img src="https://uploads-ssl.webflow.com/5c6c7d4a75c1e54694ed12d1/5c6c7d4a75c1e5183aed132e_house-rules.svg" width="100" height="100" alt="" class="house__image" />
              <div class="house-rules__text">{{ houseRules }}</div>
            </div>
          </div>
          <div v-if="petDescription" class="pets__card">
            <div class="pets__title-text">Pets</div>
            <div class="card__description-and-icon-container w-clearfix">
              <img src="@/assets/pets.svg" width="100" height="100" alt="" class="pets__image" />
              <div class="pets__text">{{ petDescription }}</div>
            </div>
          </div>
        </div>
        <div class="profile-detail__column-right w-col w-col-4 w-col-stack">
          <ul class="other-events__list">
            <li class="other-events__title-bar">
              <div class="other-events__title-text truncate">{{ userFirstName }}'s offers</div>
            </li>
            <OtherEvent v-for="event of events"
                        :key="event.id"
                        :event="event"
                        @item-click="$router.push({ name: 'EventPage', params: { id: event.id } })"
                        class="other-events__title-bar"/>
          </ul>
        </div>
      </div>
    </div>
    <LikeUserFooter v-if="showLikeUserFooter"
                    :user="user"
                    @click-yes="likeUserHandler"
                    @click-no="dislikeUserHandler"/>
  </div>
</template>

<script>
import LikeUserFooter from '@/components/base/LikeUserFooter'
import AvatarImage from '@/components/base/AvatarImage'
import SearchListCardActions from '@/components/search/SearchListCardActions'
import MainNav from '@/components/MainNav'
import Images from '@/components/Images'
import LoadingSpinner from '@/components/LoadingSpinner'
import OtherEvent from '@/components/OtherEvent'
import LightBoxStyleWrapper from '@/components/LightBoxStyleWrapper'
import LightBox from 'vue-image-lightbox'

import { item, maps, messaging } from '@/mixins'
import { fetchUser, fetchUpcomingEvents } from '@/utils/api'
import contactIcon from '@/assets/contact-black-outline.svg'

export default {
  name: 'UserPage',
  components: { MainNav, Images, LoadingSpinner, AvatarImage, OtherEvent, SearchListCardActions, LikeUserFooter, LightBox, LightBoxStyleWrapper },
  mixins: [ item, maps, messaging ],
  data () {
    return {
      user: null,
      events: null,
      mapOptions: {
        'disableDefaultUI': true, // turns off map controls
        'gestureHandling': 'none' // prevents any kind of scrolling
      }
    }
  },
  computed: {
    lightboxImages () {
      this.debug(this)
      return this.images.map(i => {
        return {
          thumb: i,
          src: i
        }
      })
    },
    targetUser () {
      return this.user
    },
    showLikeUserFooter () {
      return this.user && this.currentUser && (this.user.id !== this.currentUser.id) && !this.isStarred && !this.isDarkStarred
    },
    contactIcon () { return contactIcon }
  },
  methods: {
    handleImageClick (payload) {
      this.$refs.lightbox.showImage(payload)
    },
    async likeUserHandler () {
      this.$ga.event('Star', 'starred', 'UserPage footer')
      this.user = await this.interestedClickWithPrompts()
    },
    async dislikeUserHandler () {
      this.$ga.event('Star', 'dark-starred', 'UserPage footer')
      await this.disinterestedClick()
      this.$router.push({ name: 'DisinterestedSurvey', params: { userId: this.$route.params.id } })
    },
    async interestedClickAndUpdate () {
      this.user = await this.interestedClick()
    },
    fetchUser: async function () {
      try {
        this.user = await fetchUser(this.$route.params.id)
      } catch (e) {
        this.logError(e)
        this.$router.push({ name: 'NotFound' })
      }
      this.events = (await fetchUpcomingEvents(this.$route.params.id))
      this.$nextTick(async function () {
        await this.createMap(this.$refs.map, {
          zoom: 13,
          center: { lat: parseFloat(this.user.fuzzyLatitude),
            lng: parseFloat(this.user.fuzzyLongitude) },
          disableDefaultUI: true,
          options: this.mapOptions,
          style: 'width: 100px; height: 230px;'
        })
        await this.addCircle({ lat: this.user.fuzzyLatitude, lng: this.user.fuzzyLongitude }, 0.2)
      })
    },
    updateUser (user) {
      this.user = user
    }
  },
  created: function () {
    this.fetchUser()
    this.settlePendingWaves()
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
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

.bullet-bar {
  height: auto;
  min-width: 6px;
  clear: left;
  border-radius: 4px;
  background-color: #0dba51;
}

.protile-top-card__about-llist {
  margin-top: 28px;
  margin-bottom: 8px;
  padding-left: 0;
  list-style-type: none;
}

.about-the-host__list-item {
  display: flex;
  min-height: 30px;
  margin-bottom: 12px;
}

.about-the-host__bullet-text {
  display: flex;
  max-width: 530px;
  margin-left: 10px;
  align-items: center;
  font-size: 13px;
  line-height: 17px;
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

.attendee__list-item {
  position: relative;
  display: flex;
  width: 63px;
  margin: 8px 8px 16px;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  list-style-type: none;
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

.attendee__photo {
  width: 60px;
  height: 60px;
  border-radius: 50%;
}

.attendee__photo.photo-fit {
  width: 60px;
  height: 60px;
}

.attendee__user-name {
  overflow: hidden;
  width: 52px;
  margin-top: 12px;
  color: rgba(0, 0, 0, 0.86);
  font-size: 12px;
  line-height: 17px;
  font-weight: 400;
  text-align: center;
}

.attendee__user-name:hover {
  text-decoration: underline;
}

.attendee__link-wrapper {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  transition: all 140ms ease;
}

.attendee__link-wrapper:hover {
  transform: scale(1.1);
}

.text-block-10 {
  color: #fff;
  font-size: 12px;
  font-weight: 700;
}

.profile__container {
  display: flex;
  margin-top: 0;
  margin-bottom: 0;
  padding: 32px 32px 112px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
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

.number-container {
  display: flex;
  max-height: 24px;
  max-width: 24px;
  min-height: 24px;
  min-width: 24px;
  padding-bottom: 2px;
  justify-content: center;
  align-items: center;
  border-radius: 50%;
  background-color: #64426b;
}

.playdate-planning-bullet {
  display: flex;
  width: 100%;
  margin-bottom: 16px;
  align-items: flex-start;
}

.profile-top-card__action-button {
  background-position: center;
  position: static;
  width: 40px;
  height: 40px;
  padding: 8px;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, 0.03);
  border-radius: 4px;
  background-color: #f3f3f3;
  &.active {
    background-image: url('../assets/star_2.svg');
  }
  background-image: url('../assets/star-black-outline.svg');
}

.profile-top-card__action-button:hover {
  background-color: #eee;
}

.profile-top-card__action-button:active {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.profile-top-card__action-button-icon {
  width: 20px;
  height: 20px;
  margin-right: 0;
  opacity: 1;
}

.profile-top-card__name-action-group {
  display: flex;
  margin-bottom: 16px;
  align-items: center;
}

.profile-top-card__container {
  position: relative;
  display: flex;
  width: 100%;
  margin-top: 0;
  padding: 32px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
}

.about-host__bio-text {
  color: #1e5e7e;
  font-size: 13px;
  line-height: 21px;
}

.profile-detail__content-columns {
  min-width: 100%;
  margin-top: 16px;
  padding-bottom: 16px;
}

.profile-detail_column-left {
  padding-right: 8px;
  padding-left: 0px;
}

.profile-detail__column-right {
  padding-left: 8px;
  padding-right: 0px;
}

.profile-top-card__photo-wrapper {
  position: relative;
  display: flex;
  width: 200px;
  height: 200px;
  margin-top: 22px;
  margin-right: 22px;
  justify-content: center;
}

.profile-top-card__photo {
  position: static;
  max-height: 200px;
  max-width: 200px;
  min-height: 200px;
  min-width: 200px;
  margin: 0;
  border-radius: 4px;
}

.profile-top-card__badge-verified {
  position: absolute;
  left: auto;
  top: auto;
  right: auto;
  bottom: -14px;
  display: flex;
  min-height: 24px;
  min-width: 80px;
  justify-content: center;
  align-items: center;
  border-radius: 1000px;
  background-color: #0cba52;
  opacity: 0.92;
}

.profile-top-card__user-summary-info {
  position: relative;
  display: flex;
  margin-bottom: 0;
  flex-direction: column;
  align-items: flex-start;
}

.profile-top-card__distance {
  position: static;
  right: 0;
  margin-top: 0;
  margin-left: 13px;
  color: #64426b;
  font-size: 14px;
  line-height: 12px;
  text-transform: uppercase;
}

.profile-top-card__ages {
  overflow: hidden;
  color: rgba(0, 0, 0, 0.6);
  font-size: 13px;
  line-height: 17px;
}

.profile-top-card__occupation {
  overflow: hidden;
  margin-bottom: 6px;
  color: rgba(0, 0, 0, 0.6);
  font-size: 13px;
  line-height: 17px;
}

.profile-top-card__user-name {
  margin-top: 0;
  margin-right: 14px;
  margin-bottom: 0;
  font-size: 32px;
  line-height: 26px;
  font-weight: 400;
}

.attended__card {
  display: flex;
  width: 100%;
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

.attended__title-text {
  margin-bottom: 16px;
  font-size: 16px;
  line-height: 24px;
}

.hosted__card {
  display: flex;
  width: 100%;
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

.interests__card {
  position: static;
  display: flex;
  margin-top: 0;
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

.interests__title-text {
  margin-bottom: 16px;
  font-size: 16px;
  line-height: 24px;
}

.interests_image {
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

.interests__tag-container {
  display: block;
  width: 100%;
  margin-top: 16px;
  align-items: flex-start;
  text-align: left;
}

.availability__card {
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

.availability_image {
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

.availability__tag-container {
  display: block;
  width: 100%;
  margin-top: 16px;
  align-items: flex-start;
  text-align: left;
}

.availability__title-text {
  margin-bottom: 16px;
  font-size: 16px;
  line-height: 24px;
}

.profile__badge-text {
  margin-left: 4px;
  color: #fff;
  font-size: 8px;
  line-height: 12px;
  text-align: center;
  letter-spacing: .5px;
  text-transform: uppercase;
}

.profile__badge__check-mark {
  color: #fff;
  font-size: 8px;
  line-height: 12px;
  text-align: center;
  letter-spacing: .5px;
  text-transform: uppercase;
}

.about__description {
  position: relative;
  display: flex;
  max-width: 550px;
  min-width: 550px;
  margin-top: 28px;
  margin-left: -2px;
  padding: 18px 22px;
  justify-content: flex-start;
  border-radius: 20px 0 20px 20px;
  background-color: #d7f8ff;
  background-image: linear-gradient(45deg, #a5efff, #d7f8ff 58%);
}

.bio__triangle {
  position: absolute;
  left: auto;
  top: -23px;
  right: 104px;
  bottom: auto;
  display: none;
  width: 24px;
  height: 24px;
  border-style: solid;
  border-width: 12px;
  border-color: transparent transparent #eee;
}

.bio__read-more-link {
  color: #1f88e9;
}

.profile__user-basics-container {
  display: flex;
  width: 100%;
  flex-direction: row-reverse;
  justify-content: space-between;
  align-items: flex-start;
}

.bio__talk-bubble-caret--right {
  position: absolute;
  left: auto;
  top: 0%;
  right: -24px;
  bottom: auto;
  width: 24px;
  height: 24px;
  min-height: 24px;
  min-width: 24px;
  border-style: solid;
  border-width: 14px;
  border-color: #d7f8ff transparent transparent #d7f8ff;
}

.bio__talk-bubble-caret--top {
  position: absolute;
  left: auto;
  top: 0%;
  right: -24px;
  bottom: auto;
  display: none;
  width: 24px;
  height: 24px;
  min-height: 24px;
  min-width: 24px;
  border-style: solid;
  border-width: 14px;
  border-color: #f1f1f1 transparent transparent #f1f1f1;
}

@media (max-width: 991px){
  .event-detail__map {
    max-height: 210px;
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

  .attendee__link-wrapper:hover {
    transform: none;
  }

  .profile__container {
    padding-top: 32px;
    padding-bottom: 128px;
  }

  .profile-detail__content-columns {
    margin-top: 16px;
    max-width: 684px;
  }

  .profile-detail_column-left {
    margin-bottom: 0;
    padding-right: 10px;
    padding-left: 10px;
  }

  .map {
    margin-bottom: 10px;
  }

  .profile-detail__column-right {
    padding-left: 10px;
    padding-right: 10px;
  }

  .about__description {
    max-width: 340px;
    min-width: 340px;
  }
}

@media (max-width: 767px){
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

  .protile-top-card__about-llist {
    max-width: 365px;
    align-items: flex-start;
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

  .attendee__link-wrapper {
    margin-bottom: 0;
  }

  .profile__container {
    padding: 0 0 100px;
  }

  .tag {
    margin-right: 8px;
    margin-bottom: 10px;
    padding: 8px 14px 10px;
  }

  .tag-text2 {
    font-size: 13px;
  }

  .profile-top-card__action-button {
    margin-left: 10px;
  }

  .profile-top-card__name-action-group {
    margin-bottom: 8px;
    flex-direction: row;
    justify-content: center;
  }

  .profile-top-card__container {
    margin-top: 16px;
    padding: 16px 16px 24px;
    align-items: center;
    border-radius: 0;
  }

  .profile-detail_column-left {
    padding-right: 0;
    padding-left: 0;
  }

  .profile-detail__column-right {
    padding-right: 0;
    padding-left: 0;
  }

  .profile-top-card__photo-wrapper {
    width: 180px;
    height: 180px;
    margin-right: 0;
  }

  .profile-top-card__photo.photo-fit {
    max-height: 180px;
    max-width: 180px;
    min-height: 180px;
    min-width: 180px;
  }

  .profile-top-card__user-summary-info {
    margin-top: 24px;
    align-items: center;
  }

  .profile-top-card__distance {
    text-align: center;
  }

  .profile-top-card__ages {
    text-align: center;
  }

  .profile-top-card__occupation {
    margin-bottom: 2px;
    text-align: center;
  }

  .profile-top-card__user-name {
    margin-right: 0;
    margin-bottom: 0;
  }

  .attended__card {
    padding: 16px 16px 0;
    border-radius: 0;
  }

  .attended__title-text {
    font-size: 14px;
    line-height: 18px;
  }

  .hosted__card {
    padding: 16px 16px 0;
    border-radius: 0;
  }

  .interests__card {
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .interests__title-text {
    font-size: 14px;
    line-height: 18px;
  }

  .availability__card {
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .availability__title-text {
    font-size: 14px;
    line-height: 18px;
  }

  .profile__badge__check-mark {
    display: block;
  }

  .about__description {
    width: 300px;
    max-width: 365px;
    min-width: 365px;
    margin-left: 0;
    justify-content: center;
    border-top-right-radius: 20px;
    background-image: linear-gradient(10deg, #a5efff, #d7f8ff);
  }

  .profile__user-basics-container {
    flex-direction: column;
    align-items: center;
  }

  .bio__talk-bubble-caret--right {
    display: none;
  }

  .bio__talk-bubble-caret--top {
    left: auto;
    top: -27px;
    right: auto;
    bottom: auto;
    display: block;
    border-top-color: transparent;
    border-bottom-color: #d7f8ff;
    border-left-color: transparent;
  }

}

@media (max-width: 479px){
.profile-top-card__footer__button-list {
    width: 100%;
    margin-top: 24px;
    flex-direction: column;
}
  .profile-detail__content-columns{
    max-width: 100%;
  }
  .other-events__title-text {
    width: 270px;
  }

  .protile-top-card__about-llist {
    max-width: 288px;
  }

  .list {
    margin-right: 0;
  }

  .profile__container {
    padding-bottom: 32px;
    background-color: #f4f4f4;
  }

  .tag {
    clear: both;
  }

  .profile-top-card__container {
    padding-bottom: 16px;
  }

  .profile-top-card__photo-wrapper {
    width: 150px;
    height: 150px;
  }

  .profile-top-card__photo {
    max-height: 150px;
    max-width: 150px;
    min-height: 150px;
    min-width: 150px;
  }

  .profile-top-card__photo.photo-fit {
    max-height: 150px;
    max-width: 150px;
    min-height: 150px;
    min-width: 150px;
  }

  .profile-top-card__user-summary-info {
    margin-top: 24px;
  }

  .profile-top-card__user-name {
    font-size: 20px;
  }

  .about__description {
    width: auto;
    max-width: 300px;
    min-width: auto;
  }

}
</style>
