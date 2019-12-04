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
    <LoadingSpinner v-if="!place" />
    <div v-else class="place-detail__container w-container">

      <div class="place-card">
        <h1 class="place-title">{{ placeName }}</h1>
        <div v-if="hasReviews" class="place-ratings">
          <a href="#reviews" class="link-block w-inline-block">
            <div class="rating-stars">
              <img v-for="i in averageRating" v-bind:key="i" src="@/assets/Star_3.svg" alt="" />
              <img v-for="i in (5 - averageRating)" v-bind:key="i" src="@/assets/Star--inactive.svg" alt="" />
            </div>
            <div class="ratings-link-text">{{ numberOfReviews }} reviews</div>
          </a>
        </div>
        <div class="place-event-summary">
          <div class="link-block-2 w-inline-block"><img src="@/assets/mdi_calendar_today.svg" alt="" />
            <div class="events-link-text">{{ numberOfEvents }} events happening</div>
          </div>
        </div>
        <div class="place-event-desc">
          <div class="text-block-13">{{ placeDescription }}</div>
        </div>
      </div>

      <div class="place-photos">
        <div class="place-section-title">Photos</div><a @click="showCloudinaryWidget" class="places-links">+ Add a photo</a>
        <div class="place-photos__grid">
          <a
            v-for="(image, i) in placeImages"
            v-bind:key="image"
            @click="handleImageClick(i)"
            class="place-photo__link w-inline-block"
          >
            <img :src="image" class="place-photos__image photo-fit" />
          </a>
        </div>
      </div>

      <div class="place-events">
        <div id="events" class="place-section-title">Events</div><a @click="offerPlaydate" class="places-links">+ Add an event</a>
        <ul class="place-events-list">
          <EventSearchListCard v-for="(item, index) in upcomingItems"
                               :item="item"
                               :key="index"
                               :distanceCenter="placeCenter"
                               @user-updated="$emit('user-updated', $event)"
                               @event-deleted="$emit('event-deleted', id)"
                               @event-updated="$emit('event-updated', $event)"/>
        </ul>
      </div>

      <div v-if="hasReviews" class="place-reviews">
        <div id="reviews" class="place-section-title">Reviews</div>
        <a @click="reviewClick" class="places-links">+ Add a review</a>
      </div>

    </div>
  </div>
</template>

<script>
import LightBox from 'vue-image-lightbox'
import VueScrollTo from 'vue-scrollto'

import MainNav from '@/components/MainNav'
import LoadingSpinner from '@/components/LoadingSpinner'
import LightBoxStyleWrapper from '@/components/LightBoxStyleWrapper'
import EventSearchListCard from '@/components/search/EventSearchListCard'

import { fetchPlace, updatePlace } from '@/utils/api'
import { createWidget, householdImageUrl } from '@/utils/vendor/cloudinary'
import { item } from '@/mixins'

export default {
  name: 'PlacePage',
  components: { MainNav, LoadingSpinner, LightBox, LightBoxStyleWrapper, EventSearchListCard },
  mixins: [ item ],
  data () {
    return {
      placeId: this.$route.params.id,
      place: null,
      cloudinaryUploadWidget: null,
      showError: false
    }
  },
  computed: {
    numberOfReviews () {
      return 0
    },
    placeCenter () {
      return { lat: this.place.fuzzyLatitude, lng: this.place.fuzzyLongitude }
    },
    placeDescription () {
      return this.place.description
    },
    averageRating () {
      return 4
    },
    hasReviews () {
      return true
    },
    placeName () {
      return this.place.name
    },
    numberOfEvents () {
      let size = 0
      const obj = this.place.upcomingEvents
      for (let key in obj) {
        if (obj.hasOwnProperty(key)) { size += 1 }
      }
      return size
    },
    placeImages () {
      return this.place.images.map(url => householdImageUrl(url, 800))
    },
    lightboxImages () {
      return this.place.images.map(i => {
        return {
          thumb: i,
          src: i
        }
      })
    },
    upcomingItems () {
      const events = this.place.upcomingEvents
      if (!events) {
        return []
      }
      const items = events.map(event => {
        return { event: event, user: event.user }
      })
      return items
    }
  },
  methods: {
    reviewClick () {
      this.$router.push({ name: 'LeaveReview', params: { placeId: this.place.placeId, place: this.data.place } })
    },
    offerPlaydate () {
      this.$router.push({ name: 'NewEvent' })
    },
    cloudinaryEventHandler (error, result) {
      this.debug({ result })

      if (!error && result && result.event === 'abort') {
        this.avatarLoading = false
      }
      if (!error && result && result.event === 'success') {
        let transformation = ''
        if (result.info.coordinates.custom) {
          transformation = 'c_thumb,g_custom/'
        }
        const imageUrl = 'https://res.cloudinary.com/' + process.env.CLOUDINARY_CLOUD_NAME + '/image/upload/' + transformation + result.info.path
        this.place.images.push(imageUrl)
        this.submitPlaceData()
        this.disableForm = false
      }
    },
    submitPlaceData: async function () {
      if (!this.hasError) {
        const data = { images: this.place.images }
        try {
          const res = await updatePlace(this.placeId, data)
          this.$store.dispatch('updatePlace')
          this.log('place update SUCCESS')
          this.log(res)
        } catch (e) {
          this.logError('Error saving')
          this.logError(e)
          this.saveButtonText = 'Problem saving. Click to try again.'
        }
      } else {
        this.showError = true
        VueScrollTo.scrollTo('#top-of-form')
      }
    },
    showCloudinaryWidget () {
      this.cloudinaryUploadWidget.open()
    },
    handleImageClick (payload) {
      this.debug('handle')
      this.$refs.lightbox.showImage(payload)
    },
    fetchPlace: async function (id = this.$route.params.id) {
      try {
        this.place = await fetchPlace(id)
      } catch (e) {
        this.logError(e)
        this.$router.push({ name: 'NotFound' })
      }
    }
  },
  async created () {
    await this.fetchPlace()
    this.cloudinaryUploadWidget = createWidget(this.cloudinaryEventHandler, {
      multiple: true
    })
  }
}
</script>

<style scoped lang="scss">

a {
  color: #000;
  text-decoration: none;
}

.place-detail__container {
  margin-top: 32px;
  padding-right: 32px;
  padding-left: 32px;
}

.place-card {
  position: static;
  z-index: 1000;
  display: flex;
  width: 100%;
  margin-top: 0;
  margin-bottom: 16px;
  padding: 32px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: none;
}

.place-title {
  margin-top: 0;
  margin-bottom: 8px;
  font-size: 24px;
  line-height: 36px;
}

.place-ratings {
  display: flex;
  width: 100%;
  margin-bottom: 8px;
  padding-top: 0;
  padding-bottom: 0;
  align-items: center;
}

.place-event-summary {
  display: flex;
  width: 100%;
  margin-bottom: 8px;
  align-items: center;
}

.place-event-desc {
  width: 100%;
}

.rating-stars {
  display: flex;
  align-items: center;
  align-self: auto;
}

.ratings-link-text {
  margin-left: 8px;
  padding-left: 0;
  color: #1f88e9;
}

.link-block {
  display: flex;
  padding-top: 4px;
  padding-right: 8px;
  padding-bottom: 4px;
  align-items: center;
}

.events-link-text {
  margin-left: 8px;
  padding-left: 0;
  color: #1f88e9;
}

.link-block-2 {
  display: flex;
  padding-top: 4px;
  padding-right: 8px;
  padding-bottom: 4px;
  align-items: center;
}

.text-block-13 {
  color: grey;
}

.place-section-title {
  margin-bottom: 6px;
  font-size: 18px;
  line-height: 24px;
  font-weight: 700;
}

.place-photos {
  position: relative;
  display: flex;
  width: 100%;
  min-height: 201px;
  margin-top: 0;
  margin-bottom: 18px;
  padding: 16px 20px 18px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: none;
  list-style-type: none;
}

.place-photos__grid {
  position: relative;
  display: flex;
  margin: 20px -12px -2px -2px;
  flex-direction: row;
  justify-content: flex-start;
  flex-wrap: wrap;
  align-items: flex-start;
}

.place-photo__link {
  position: relative;
  overflow: hidden;
  width: 32%;
  margin: 2px;
  padding-top: 33%;
  background-color: #d59191;
}

.place-photos__image {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}

.places-links {
  padding-top: 4px;
  padding-bottom: 4px;
  align-self: flex-start;
  color: #1f88e9;
}

.places-links:hover {
  background-color: rgba(0, 0, 0, 0.06);
}

.place-events {
  position: relative;
  display: flex;
  width: 100%;
  min-height: 201px;
  margin-top: 0;
  margin-bottom: 18px;
  padding: 16px 20px 18px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: none;
  list-style-type: none;
}

.place-events-list {
  margin-top: 8px;
  padding-left: 0;
  list-style-type: none;
}

.place-reviews {
  position: relative;
  display: flex;
  width: 100%;
  min-height: 201px;
  margin-top: 0;
  margin-bottom: 18px;
  padding: 16px 20px 18px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: none;
  list-style-type: none;
}

@media (max-width: 991px){
  .place-photos__grid {
    margin-right: -17px;
    margin-bottom: 2px;
  }

  .places-links:hover {
    background-color: transparent;
  }

  .places-links:active {
    background-color: rgba(0, 0, 0, 0.06);
  }

}

@media (max-width: 767px){

  .place-detail__container {
    margin-top: 16px;
    padding-right: 0;
    padding-left: 0;
  }

  .place-card {
    margin-top: 16px;
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .place-title {
    text-align: left;
  }

  .place-events {
    min-height: 186px;
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .place-events-list {
    margin-right: -16px;
    margin-left: -16px;
  }
}

@media (max-width: 479px){
  .place-card {
    padding-bottom: 16px;
  }
}

</style>
