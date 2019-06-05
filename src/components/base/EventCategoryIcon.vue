<template>
<img :src="iconUrl"
 :width="width" :height="height" alt="">
</template>

<script>

export default {
  name: 'EventCategoryIcon',
  props: ['width', 'height', 'category'],
  computed: {
    iconUrl: function () {
      return require('@/assets/' + this.iconImage)
    },
    iconImage: function () {
      if (!this.category) {
        return 'sun.svg'
      }
      switch (this.category.toLowerCase()) {
        case 'baby playgroup':
          return 'hatching-chick.svg'
        case 'drawing & coloring':
          return 'crayon.svg'
        case 'movie night':
        case 'kids\' movie night':
          return 'movie-camera.svg'
        case 'arts & crafts':
          return 'artist-palette.svg'
        case 'games & puzzles':
          return 'chess-pawn.svg'
        case 'board games':
          return 'chess-pawn.svg'
        case 'baking':
          return 'birthday-cake.svg'
        case 'book club':
        case 'books & storytime':
          return 'books.svg'
        case 'waldorf nature walk':
          return 'seedling.svg'
        case 'playground meetup':
          return 'monkey.svg'
        case 'playing outside (weather permitting)':
          return 'sun-behind-small-cloud.svg'
        default:
          return 'sun.svg'
      }
    }
  }
}
</script>
