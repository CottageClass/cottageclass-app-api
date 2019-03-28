<template>
  <Question
    title="Choose Profile Photos"
    subtitle="Choose the photos that best represent you, your family, or any activities you’d like to share.">
    <div class="image-wrapper">
      <div v-for="(imageUrl, index) in facebookThumbs"
          class="image-container"
          @click="toggleImageSelection(index)">
        <img class="facebook-thumb" :src=imageUrl>
        <div v-if="isChecked(index)" class="selection-container selected">
          <img src="@/assets/check-green.svg">
        </div>
        <div v-else class="selection-container unselected" />
      </div>
      <div class="facebook-thumb blank"></div>
      <div class="facebook-thumb blank"></div>
      <div class="facebook-thumb blank"></div>
      <div class="facebook-thumb blank"></div>
      <div class="facebook-thumb blank"></div>
      <div class="facebook-thumb blank"></div>
    </div>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import { fetchFacebookImages } from '@/utils/api'
import { mapGetters } from 'vuex'
import _ from 'lodash'

export default {
  name: 'FacebookImageSelection',
  components: { Question },
  props: ['value'],
  data () {
    return {
      facebookImageData: null,
      state: { },
      selectedIndices: []
    }
  },
  methods: {
    loadFacebookThumbs: async function () {
      if (!this.currentUser.facebookAccessToken) { return }
      try {
        this.facebookImageData = await fetchFacebookImages(this.currentUser.facebookAccessToken)
        if (!this.facebookImageData || this.facebookImageData.length === 0) {
          this.$emit('noImages')
        }
      } catch (e) {
        console.log(e)
      }
    },
    toggleImageSelection (index) {
      // create a copy, alter it and reassign it to selectedIndices.  This will force Vue to react to the change
      const selectedIndicesCopy = _.concat(this.selectedIndices)
      if (_.includes(this.selectedIndices, index)) {
        _.pull(selectedIndicesCopy, index)
      } else {
        selectedIndicesCopy.push(index)
      }
      this.selectedIndices = selectedIndicesCopy
      this.setState()
      this.$emit('input', this.state)
    },
    setState () {
      this.state = _.map(this.selectedIndices, i => this.facebookFullSizeImages[i])
    }
  },
  computed: {
    facebookThumbs: function () {
      const THUMB_SIZE = 95
      return _.map(this.facebookImageData, allSizes => {
        const bigEnoughImages = _.filter(allSizes.images, oneSize => {
          return oneSize.width > THUMB_SIZE && oneSize.height > THUMB_SIZE
        })
        if (bigEnoughImages) {
          return _.minBy(bigEnoughImages, i => i.width).source
        } else {
          return _.maxBy(allSizes.images, oneSize => oneSize.width).source
        }
      })
    },
    facebookFullSizeImages: function () {
      return _.map(this.facebookImageData, allSizes => {
        return _.maxBy(allSizes.images, oneSize => oneSize.width).source
      })
    },
    isChecked () {
      return function (i) {
        return _.includes(this.selectedIndices, i)
      }
    },
    ...mapGetters([ 'currentUser' ])
  },
  watch: {
    value: function () {
      this.state = this.value
    }
  },
  mounted () {
    this.state = this.value
  },
  created () {
    this.loadFacebookThumbs()
  }
}

</script>

<style>
.facebook-thumb {
  height: 95px;
  width: 95px;
  object-fit: cover;
  margin: 4px;
}
.blank {
  height: 0;
}
.image-container {
  position: relative;
}
.selection-container {
  position: absolute;
  top: 8px;
  right: 8px;
  display: flex;
  width: 24px;
  height: 24px;
  justify-content: center;
  align-items: center;
  border: 1px solid #ffd6d6;
  border-radius: 50%;
  box-shadow: 0 0 6px 0 rgba(0, 0, 0, .3), inset 0 0 8px 0 rgba(0, 0, 0, .3);
}
.selected {
  background-color: #383838;
}
.image-wrapper {
  display: flex;
  justify-content: space-around;
  flex-wrap: wrap;
}
@media (max-width: 374px) {
  .facebook-thumb {
    width: 90px;
    height: 90px;
    margin: 3px;
  }
  .blank {
    height: 0;
  }
}
</style>
