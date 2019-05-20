<template>
  <div class="item-container" @click="toggleSelected">
    <div class="time-label">
      {{ timeText }}
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { } from '@/mixins'

export default {
  name: 'MultipleTimeSelectorItem',
  props: ['startHour', 'selected'],
  components: {},
  mixins: [],
  data () {
    return {
    }
  },
  computed: {
    timeText () {
      return this.toCompactTime(this.startHour) + ' - ' + this.toCompactTime((this.startHour + 1) % 24)
    },
    toCompactTime () {
      return hour => (hour + 11) % 12 + 1 + (hour < 12 ? 'am' : 'pm')
    },
    ...mapGetters([])
  },
  methods: {
    toggleSelected () {
      this.$emit('input', !this.selected)
    }
  },
  mounted () {
  }
}
</script>

<style scoped>

</style>
