<template>
  <div>
    <div class="day-of-week"
         v-for="(day, index) of shiftedDays">
      {{ day  +index }}
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { } from '@/mixins'

const WEEK_DAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

export default {
  name: 'MultipleTimeSelector',
  props: ['selectedItems', 'firstDisplay'],
  components: {},
  mixins: [],
  data () {
    return {
    }
  },
  computed: {
    firstDay () {
      return Math.floor(this.firstDisplay / 24)
    },
    firstTime () {
      return Math.max(8, this.firstDisplay % 24)
    },
    shiftedDays () {
      return [0, 1, 2, 3, 4, 5, 6, 7].map(i => WEEK_DAYS[(i + this.firstDay) % 7])
    },
    ...mapGetters([])
  },
  methods: {
  },
  mounted () {
  }
}
</script>

<style scoped>

</style>
