<template>
  <Question
    title="Write a Review"
    :subtitle= subtitleText
    class="unpadded">
    <div class="rating-container">
      <v-rating
        v-model="stars"
        id="field"
        :x-large= true
        :hover= true
        color= "black"
        background-color="black"
      />
    </div>
    <FormWithTextArea
      class="tall"
      maxLength="30000"
      placeholder="What's it like to be there with a child? What's great? What's not ideal?"
      v-model="content" />
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import { fetchPlace } from '@/utils/api'
import { postPlaceReview } from '@/utils/api/placeReviews'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'
import { alerts, goHome } from '@/mixins/'
import { mapGetters } from 'vuex'

export default {
  name: 'LeaveReview',
  components: { Question, FormWithTextArea },
  mixins: { alerts, goHome },
  data () {
    return {
      place: null,
      stars: { default: null },
      content: ''
    }
  },
  methods: {
    fetchPlace: async function () {
      try {
        this.place = await fetchPlace(this.$route.params.placeId)
      } catch (e) {
        this.logError(e)
        this.$router.push({ name: 'NotFound' })
      }
    },
    postPlaceReview: async function () {
      const res = postPlaceReview({
        placeId: this.place.id,
        stars: this.stars,
        content: this.content
      })
      console.log(res)
      this.goHome()
    }
  },
  computed: {
    errorMessage () {
      return (this.stars) ? null : 'Please enter a review'
    },
    subtitleText () {
      return `How kid friendly is this place?`
    }
  },
  async created () {
    await this.fetchPlace()
    this.$emit('set-nav-props', {
      nextButtonHandler: this.postPlaceReview,
      button: 'done'
    })
  },
  watch: {
    '$route': {
      handler () {
        this.fetchUser()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.flow {
  .unpadded {
    padding: 0;
  }

  .rating-container {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 30px
  }
}
</style>
