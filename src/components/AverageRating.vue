<template>
  <div class="star-ratings-css">
    <div class="star-ratings-css-top" :style="ratingStyle"><span>★</span><span>★</span><span>★</span><span>★</span><span>★</span></div>
    <div class="star-ratings-css-bottom"><span>★</span><span>★</span><span>★</span><span>★</span><span>★</span></div>
  </div>
</template>

<script>

export default {
  name: 'AverageRating',
  components: { },
  props: {
    averagePercentage: {
      type: Number,
      default: 100
    }
  },
  computed: {
    ratingStyle () {
      return {
        width: `${this.averagePercentage}%`
      }
    }
  }
}
</script>

<style scoped lang="scss">
.star-ratings-css {
  color: #c5c5c5;
  font-size: 15px;
  height: 15px;
  width: 75px;
  margin: 0;
  position: relative;
  padding: 0;

  &-top {
    color: #fc6f77;
    padding: 0;
    position: absolute;
    z-index: 1;
    display: block;
    top: 0;
    left: 0;
    overflow: hidden;
  }
  &-bottom {
    padding: 0;
    display: block;
    z-index: 0;
  }
}

</style>
