<template>
  <div class="onb-body">
    <MainNav />
    <StyleWrapper styleIs="editing">
      <LoadingSpinner v-if="!user"/>
      <div v-else class="profile-container w-container">
        <div ref="map" class="map-container" />
        <div class="top-card">
          <div class="top-card-summary-info">
            <div class="top-card-column-1">
              <h1 class="name-heading">{{ user.firstName }}</h1>
              <div class="top-card-subtitle"><span>{{ user.neighborhood || user.adminAreaLevel1 }}</span> |
                <span v-if="user && user.childAges && user.childAges.length > 0" class="providerp-children">
                    Parent to <ChildAges :childAges="user.childAges" singular="child" plural="children" />.
                </span>
              </div>
              <div v-if="employmentDescription" class="top-card-info-bullet">
                  <div class="occupation">{{ employmentDescription }}</div>
              </div>
              <div v-if="user.languages.length" class="top-card-info-bullet">
                <div class="languages">{{ languageText }}</div>
              </div>
              <div class="top-card-info-bullet">
                <div class="member-since">Member since {{joinedDateFormatted}}</div>
              </div>
              <div v-if="user.verified" class="top-card-info-bullet">
                <div class="background-checked-wrapper">
                  <img src="@/assets/check-green.svg" alt="">
                  <div class="background-checked">Background Checked</div>
                </div>
              </div>
            </div>
            <div class="top-card-column-2">
              <AvatarImage :person="user" className="avatar"/>
            </div>
          </div>
          <div v-if="isCurrentUser" class="top-sub-card">
              <div @click="goToEdit" class="button edit-button w-button">Edit Your Profile</div>
          </div>
          <div v-else class="top-sub-card">
            <MeetButton :targetUser="user" fillStyle="solid" class="button" layoutStyle="fat"/>
            <a class="button request-button w-button inactive">Request Childcare</a>
            <div class="request-childcare-help-text">(Once you have your first playdate you can request childcare too)</div>
          </div>
        </div>
        <div class="mobile-cards-wrapper">
          <div class="profile-specifics-card" v-if="!isCurrentUser">
            <div class="card-large-text">How to plan a playdate with {{user.firstName}}</div>
            <ul class="playdate-planning-bullet-wrapper">
              <li class="playdate-planning-bullet">
                <div class="number-bullet">1</div>
                <div class="playdate-bullet-text">Click &#x27;invite for a playdate&#x27; above</div>
              </li>
              <li class="playdate-planning-bullet">
                <div class="number-bullet">2</div>
                <div class="playdate-bullet-text">Manisha will get a text that you&#x27;re intestested in a playdate</div>
              </li>
              <li class="playdate-planning-bullet">
                <div class="number-bullet">3</div>
                <div class="playdate-bullet-text">Decide on a time and place to meet. (We recommend meeting in one of your homes).</div>
              </li>
            </ul>
          </div>
          <div v-if="user.profileBlurb && user.profileBlurb.length" class="profile-specifics-card">
            <img src="@/assets/about.svg" width="100" height="100" alt="">
            <div class="card-small-text">About Manisha</div>
            <div class="card-large-text blurb">{{user.profileBlurb}}</div>
          </div>
          <div v-if="user.images && user.images.length" class="profile-specifics-card">
            <img src="@/assets/photos.svg" width="100" height="100" alt="">
            <div class="card-small-text">Household Photos<span class="text-span"></span></div>
            <div class="div-block-40">
              <Images :images="user.images" />
            </div>
          </div>
          <div v-if="user.activities && user.activities.length" class="profile-specifics-card">
            <img src="@/assets/interests.svg" width="100" height="100" alt="">
            <div class="card-small-text">Interests</div>
            <div class="tag-container">
              <div v-for="activity in user.activities"
                   :key="activity"
                   class="tag">
                <div class="tag-text">{{activity}}</div>
              </div>
            </div>
          </div>
          <div class="profile-specifics-card" v-if="anyAvailability">
            <img src="@/assets/time.svg" width="100" height="100" alt="">
            <div class="card-small-text">Available Times</div>
            <div class="tag-container">
              <div class="tag" v-if="user.availableMornings">
                <div class="tag-text">9am-3pm</div>
              </div>
              <div class="tag" v-if="user.availableAfternoons">
                <div class="tag-text">3pm-7pm</div>
              </div>
              <div class="tag" v-if="user.availableEvenings">
                <div class="tag-text">7pm- ?</div>
              </div>
              <div class="tag" v-if="user.availableWeekends">
                <div class="tag-text">Weekends</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </StyleWrapper>
    <PageActionsFooter v-if="isCurrentUser && this.isMobile"
                       class='edit-button'
                       :buttons="[{text: 'EDIT'}]"
                       @primary-click="goToEdit"/>

    <PageActionsFooter v-else-if="isPhone"
                       :buttons="inviteFooterButtons">
      <template v-slot:first>
        <MeetButton
          :targetUser="user"
          fillStyle="solid"
          layoutStyle="slim" />
      </template>
    </PageActionsFooter>
  </div>
</template>

<script>
import Images from '@/components/Images.vue'
import AvatarImage from '@/components/base/AvatarImage'
import * as api from '@/utils/api.js'
import ChildAges from '@/components/ChildAges.vue'
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import LoadingSpinner from '@/components/LoadingSpinner.vue'
import MeetButton from '@/components/base/MeetButton'

import moment from 'moment'
import PageActionsFooter from '@/components/PageActionsFooter.vue'
import Footer from '@/components/Footer.vue'
import MainNav from '@/components/MainNav.vue'
import { mapGetters } from 'vuex'
import { maps, screen } from '@/mixins'
import _ from 'lodash'
import languageList from 'language-list'

export default {
  name: 'ProviderProfile',
  components: { Images, AvatarImage, ChildAges, StyleWrapper, PageActionsFooter, MainNav, Footer, LoadingSpinner, MeetButton },
  data () {
    return {
      user: null,
      mapOptions:
       { // move this to map component when i separate it.
         'disableDefaultUI': true, // turns off map controls
         'gestureHandling': 'none' // prevents any kind of scrolling
       }
    }
  },
  mixins: [ maps, screen ],
  methods: {
    goToEdit: function () {
      this.$router.push({ name: 'ProfileEdit' })
    },
    async setUser () {
      this.user = await api.fetchUser(this.$route.params.id)
      // wait until the next tick so the map div exists
      this.$nextTick(async function () {
        await this.createMap(this.$refs.map, {
          zoom: 14,
          center: this.userLocation,
          disableDefaultUI: true,
          options: this.mapOptions,
          style: 'width: 100px; height: 230px;'
        })
        await this.addCircle({ lat: this.user.fuzzyLatitude, lng: this.user.fuzzyLongitude }, 0.2)
      })
    }
  },
  watch: {
    '$route' (to, from) {
      this.setUser()
    }
  },
  mounted: async function () {
    this.setUser()
  },
  computed: {
    inviteFooterButtons () {
      return [{}, {
        text: 'Request childcare',
        active: false
      }]
    },
    employmentDescription: function () {
      const position = this.user.jobPosition
      const employer = this.user.employer
      if (position && employer) {
        return position + ', ' + employer
      } else if (position) {
        return position
      } else if (employer) {
        return employer
      } else {
        return null
      }
    },
    userLocation: function () {
      return { lat: parseFloat(this.user.fuzzyLatitude), lng: parseFloat(this.user.fuzzyLongitude) }
    },
    joinedDateFormatted: function () {
      return moment(this.user.createdAt).format('MMMM, YYYY')
    },
    isCurrentUser: function () {
      if (!this.currentUser) { return false }
      return this.currentUser.id.toString() === this.$route.params.id.toString()
    },
    languageText: function () {
      const languageCodes = this.user.languages
      const languages = _.map(languageCodes, languageList().getLanguageName)
      return 'Speaks ' + [languages.slice(0, -1).join(', '), _.last(languages)].join(' and ')
    },
    anyAvailability: function () {
      return this.user.availableMornings ||
             this.user.availableAfternoons ||
             this.user.availableEvenings ||
             this.user.availableWeekends
    },
    ...mapGetters([ 'currentUser' ])
  }
}

</script>
<style scoped lang="scss">
.tag-container {
  display: block;
  width: 100%;
  margin-top: 16px;
  align-items: flex-start;
  text-align: center;
}
.tag-text {
  margin-top: 1px;
  color: #333;
  font-size: 14px;
  line-height: 9px;
  font-weight: 400;
  text-transform: none;
}
.tag {
  display: inline-block;
  margin-right: 10px;
  margin-bottom: 12px;
  padding: 14px 21px 16px;
  clear: none;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, .11);
  border-radius: 20px;
  background-color: transparent;
}
.playdate-planning-bullet-wrapper {
  margin-top: 32px;
  padding-left: 0px;
}
.playdate-planning-bullet {
  display: flex;
  flex-direction: row;
  margin-bottom: 16px;
}
.number-bullet {
  display: flex;
  max-height: 24px;
  max-width: 24px;
  min-height: 24px;
  min-width: 24px;
  padding-bottom: 2px;
  margin-right: 10px;
  justify-content: center;
  align-items: center;
  border-radius: 50%;
  background-color: #64426b;
  color: white;
}
ul {
  list-style: none;
}
.card-small-text {
  margin-top: 16px;
  font-size: 13px;
  line-height: 20px;
}
.card-large-text{
  width: 80%;
  margin-top: 16px;
  font-size: 18px;
  line-height: 28px;
  text-align: center;
}
.profile-specifics-card {
  display: flex;
  width: 100%;
  margin-top: 16px;
  margin-bottom: 16px;
  padding: 32px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, .08);
}

.mobile-cards-wrapper {
  width: 100%;
}
.request-childcare-help-text {
  margin-top: 10px;
  color: rgba(0, 0, 0, .5);
  font-size: 12px;
  text-align: center;
}
.button {
  min-width: 160px;
  margin-top: 0px;
  margin-bottom: 10px;
  padding: 12px;
  border-radius: 4px;
  text-align: center;
}
.edit-button {
  color: white;
}
.request-button {
  background-color: white;
  opacity: 0.3;
  color: hsla(208, 82%, 51%, 1.00);
  border: 1px hsla(208.8118811881188, 82.11%, 51.76%, 1.00) solid;
  margin-bottom: 0px;
  &.inactive {
    &:hover {
      text-decoration: none;
      cursor: default;
    }
    opacity: 0.3;
    border-color: #1f88e9;
  }
}
.top-card {
  display: flex;
  width: 100%;
  margin-top: 0px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  align-self: center;
  border-bottom: 1px solid rgba(0, 0, 0, .06);
  background-color: #fff;
}
.top-sub-card {
  * {
    width: 40%;
  }
  border-top: 1px lightgray solid;
  width: 100%;
  display: flex;
  flex-direction: column;
  width: 100%;
  align-items: center;
  padding: 32px;
  justify-content: center;
  align-items: center;
  align-self: center;
  background-color: #fff;
}
.top-card-summary-info {
  padding: 32px;
  display: flex;
  flex-direction: row;
  width: 100%;
  min-height: 240px;
  justify-content: space-between;
  align-items: flex-start;
  border-bottom: 1px grey;
}

.top-card-column-1 {
  width: 100%;
  min-height: 200px;
  padding-right: 32px;
}

.top-card-column-2 {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}
.onb-body {
  background-color: #f6f6f6;
}
.profile-container {
  display: flex;
  margin-top: 0px;
  margin-bottom: 0px;
  padding: 32px 32px 112px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
}
.map-container {
  min-height: 150px;
  min-width: 100%;
}
.avatar {
  min-height: 200px;
  min-width: 200px;
  margin-top: 12px;
  margin-bottom: 12px;
  border-radius: 50%;
}
.name-heading {
  margin-top: 0px;
  margin-bottom: 10px;
  font-size: 35px;
  line-height: 49px;
  text-align: left;
  letter-spacing: -0.5px;
}
.top-card-subtitle {
  margin-bottom: 16px;
  font-size: 18px;
  line-height: 28px;
  text-align: left;
}
.top-card-info-bullet div {
  margin-top: 3px;
  margin-bottom: 4px;
}
.top-card-info-bullet {
  display: flex;
  margin-bottom: 8px;
  flex-direction: row;
  align-items: stretch;
  &:before {
    content: '';
    margin-right: 12px;
    min-width: 6px;
    border-radius: 4px;
    background-color: hsla(143, 86%, 39%, 1.0);
  }
}
div.background-checked-wrapper {
  display: flex;
  margin-top: 0;
  margin-bottom: 0;
  img {
    padding-top: 0;
    padding-bottom: 0;
  }
  .background-checked {
    padding: 0;
    margin-left: 4px;
    color: #000;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 1.5px;
    text-transform: uppercase;
  }
}
@media (max-width: 991px){
  .profile-container {
      padding-top: 32px;
      padding-bottom: 128px;
  }
}
@media (max-width: 767px){
  .tag {
      margin-right: 8px;
      margin-bottom: 10px;
      padding: 8px 14px 10px;
  }
  .tag-text {
    font-size: 13px;
  }
  .playdate-planning-bullet-wrapper {
    width: 60%;
  }
  .mobile-cards-wrapper {
    padding-right: 16px;
    padding-left: 16px;
  }
  .avatar {
    margin-top: 0px;
    max-height: 150px;
    max-width: 150px;
    min-height: 150px;
    min-width: 150px;
  }
  .profile-container {
      padding: 0px 0px 100px;
  }
  .card-large-text {
    width: 88%;
  }
  .top-sub-card {
    * {
      width: 60%;
    }
  }
}
@media (max-width: 479px){
  .playdate-planning-bullet-wrapper {
    width: 100%;
  }
  .top-sub-card * {
    width: 100%;
  }
  .name-heading {
    font-size: 20px;
    line-height: 26px;
    text-align: center;
  }
  .top-card-subtitle {
    width: 100%;
    font-size: 16px;
    line-height: 24px;
    text-align: center;
  }
  .avatar {
    margin-top: 0px;
    max-height: 200;
    max-width: 200px;
    min-height: 200px;
    min-width: 200px;
  }
  .top-card-summary-info {
    flex-direction: column;
    align-items: center;
  }
  .top-card-column-1 {
    order: 2;
  }
  .profile-container {
      padding-bottom: 32px;
      background-color: #f4f4f4;
  }
  .card-large-text {
    width: 100%;
    font-size: 16px;
    line-height: 24px;
  }
  .top-card-column-2 {
    margin-bottom: 20px;
    order: -1;
  }
  .top-card-column-1 {
    padding-right: 0px;
  }
}

/* Remove inner shadow from inputs on mobile iOS */

html {
  -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
}
</style>
