<template>
  <div class="review-detail--message">
    <div class="review-detail--avatar">
      <router-link
        :to="{name:'UserPage',params:{id:reviewer.id}}">
        <AvatarImage
          className="image-9"
          :person="reviewer"
          imageSize="48"
        />
      </router-link>
    </div>
    <div class="review-detail--text-group">
      <div class="review-detail--name-rating">
        {{reviewerName}}
      </div>
      <div class="rating-container"> <AverageRating :averagePercentage= rating /> </div>

      <div class="review-detail--comment" v-if="content">{{content}}</div>
    </div>
  </div>
</template>

<script>
import AvatarImage from '@/components/base/AvatarImage'
import AverageRating from '@/components/AverageRating.vue'

export default {
  name: 'ReviewCard',
  components: { AvatarImage, AverageRating },
  props: {
    review: { required: true }
  },
  computed: {
    reviewer () {
      return this.review.user
    },
    reviewerName () {
      return this.reviewer.firstName + ' ' + this.reviewer.lastInitial + '.'
    },
    rating () {
      return this.review.stars * 20
    },
    content () {
      return this.review.content
    }
  },
  async created () {
    console.log('START')
  }
}
</script>

<style scoped lang="scss">
.review-detail--message {
  min-width: 300px;
  border: 1px black;
  position: relative;
  display: flex;
  padding-top: 16px;
  padding-bottom: 16px;
  flex-direction: row;
  align-items: flex-start;
  background-color: #fff;
}

.rating-container {
  display: flex;
  margin-top: 0px;
  margin-bottom: 10px;
  padding-top: 0;
  padding-bottom: 0;
  align-items: left;
}

.image-9 {
  width: 48px;
  height: 48px;
  min-height: 48px;
  min-width: 48px;
  border-radius: 8px;
}

.review-detail--text-group {
  width: 100%;
  margin-top: -6px;
  padding-right: 16px;
  padding-left: 0;
  background-color: #fff;
}

.review-detail--name-rating {
  font-size: 16px;
  line-height: 24px;
  font-weight: 700;
}

.review-detail--rating {
  color: grey;
  font-size: 14px;
  line-height: 22px;
  font-weight: 400;
}

.review-detail--comment {
  color: grey;
}

.review-detail--avatar {
  padding-right: 16px;
  padding-left: 16px;
}
</style>
