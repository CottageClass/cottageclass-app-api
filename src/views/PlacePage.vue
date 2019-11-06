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
        <div v-if="false" class="place-ratings">
          <a href="#reviews" class="link-block w-inline-block">
            <div class="rating-stars">
              <img v-for="i in averageRating" src="@/assets/Star_3.svg" alt="" />
              <img v-for="i in (5 - averageRating)" src="@/assets/Star--inactive.svg" alt="" />
            </div>
            <div class="ratings-link-text">3 reviews</div>
          </a>
        </div>
        <div class="place-event-summary"><a href="#events" class="link-block-2 w-inline-block"><img src="@/assets/mdi_calendar_today.svg" alt="" />
          <div class="events-link-text">{{numberOfEvents}} events happening</div>
        </a></div>
        <div class="place-event-desc">
          <div class="text-block-13">This roadside attraction features a giant, 35-ft. fork weighing 11 tons emerging from the ground. This roadside attraction features a giant, 35-ft. fork weighing 11 tons emerging from the ground. This roadside attraction features a giant, 35-ft. fork weighing 11 tons emerging from the ground.This roadside attraction features a giant, 35-ft. fork weighing 11 tons emerging from the ground.</div>
        </div>
      </div>

      <div class="place-photos">
        <div class="place-section-title">Photos</div><a href="#" class="places-links">+ Add a photo</a>
        <div class="place-photos__grid">
          <a
            v-for="(image, i) in placeImages"
            @click="handleImageClick(i)"
            class="place-photo__link w-inline-block"
          >
            <img :src="image" class="place-photos__image photo-fit" />
          </a>
        </div>
      </div>

      <div class="place-events">
        <div id="events" class="place-section-title">Events</div><a href="#" class="places-links">+ Add an event</a>
        <ul class="place-events-list">
        </ul>
      </div>

      <div v-if="false" class="place-reviews">
        <div id="reviews" class="place-section-title">Reviews</div><a href="#" class="places-links">+ Add a review</a>
      </div>

    </div>
  </div>
</template>

<script>
import LightBox from 'vue-image-lightbox'
import MainNav from '@/components/MainNav'
import LoadingSpinner from '@/components/LoadingSpinner'
import LightBoxStyleWrapper from '@/components/LightBoxStyleWrapper'

import { fetchPlace } from '@/utils/api'
import { householdImageUrl } from '@/utils/vendor/cloudinary'
import { item } from '@/mixins'

export default {
  name: 'PlacePage',
  components: { MainNav, LoadingSpinner, LightBox, LightBoxStyleWrapper },
  mixins: [ item ],
  data () {
    return {
      placeId: this.$route.params.id,
      place: null
    }
  },
  computed: {
    averageRating () {
      return 3
    },
    placeName () {
      return this.place.place[this.placeId].attributes.name
    },
    numberOfEvents () {
      let size = 0
      const obj = this.place.event
      for (let key in obj) {
        if (obj.hasOwnProperty(key)) { size += 1 }
      }
      return size
    },
    placeImages () {
      return this.place.place[this.placeId].attributes.images.map(url => householdImageUrl(url, 200))
    },
    lightboxImages () {
      return this.place.place[this.placeId].attributes.images.map(i => {
        return {
          thumb: i,
          src: i
        }
      })
    }
  },
  methods: {
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
