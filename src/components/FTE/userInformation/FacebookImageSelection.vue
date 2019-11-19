<template>
  <div>
    <LoadingSpinner v-if="loading" />
    <Question v-else
              title="Choose Profile Photos"
              subtitle="Choose the photos that best represent you, your family, or any activities you’d like to share.">
      <div class="image-wrapper">
        <div v-for="(imageUrl, index) in facebookThumbs"
             v-bind:key="index"
             class="image-container"
             @click="toggleImageSelection(index)">
          <img class="facebook-thumb" :src=imageUrl>
          <div v-if="isChecked(index)" class="selection-container selected">
            <img src="@/assets/check-green.svg">
          </div>
          <div v-else class="selection-container unselected" />
        </div>
        <!-- these are here to bad the flex display.  The last line is awkward if we don't have them -->
        <div class="facebook-thumb blank"></div>
        <div class="facebook-thumb blank"></div>
        <div class="facebook-thumb blank"></div>
        <div class="facebook-thumb blank"></div>
        <div class="facebook-thumb blank"></div>
        <div class="facebook-thumb blank"></div>
      </div>
    </Question>
  </div>
</template>

<script>
import Question from '@/components/base/Question.vue'
import LoadingSpinner from '@/components/LoadingSpinner.vue'

import { fetchFacebookImages } from '@/utils/vendor'
import { minBy, maxBy } from '@/utils/utils'
import { mapGetters } from 'vuex'

export default {
  name: 'FacebookImageSelection',
  components: { Question, LoadingSpinner },
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
        this.$emit('noImages')
        console.log(e)
      }
    },
    toggleImageSelection (index) {
      // create a copy, alter it and reassign it to selectedIndices.  This will force Vue to react to the change
      const selectedIndicesCopy = this.selectedIndices.concat()
      if (this.selectedIndices.indexOf(index) >= 0) {
        selectedIndicesCopy.splice(this.selectedIndices.indexOf(index), 1)
      } else {
        selectedIndicesCopy.push(index)
      }
      this.selectedIndices = selectedIndicesCopy
      this.setState()
      this.$emit('input', this.state)
    },
    setState () {
      this.state = this.selectedIndices.map(i => this.facebookFullSizeImages[i])
    }
  },
  computed: {
    facebookThumbs: function () {
      const THUMB_SIZE = 95
      return this.facebookImageData.map(allSizes => {
        const bigEnoughImages = allSizes.images.filter(oneSize => {
          return oneSize.width > THUMB_SIZE && oneSize.height > THUMB_SIZE
        })
        if (bigEnoughImages) {
          return minBy(bigEnoughImages, i => i.width).source
        } else {
          return maxBy(allSizes.images, oneSize => oneSize.width).source
        }
      })
    },
    facebookFullSizeImages: function () {
      return this.facebookImageData.map(allSizes => {
        return maxBy(allSizes.images, oneSize => oneSize.width).source
      })
    },
    isChecked () {
      return function (i) {
        return this.selectedIndices.includes(i)
      }
    },
    loading () {
      return !this.facebookImageData
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
