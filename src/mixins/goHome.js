import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters(['itemType'])
  },
  methods: {
    goHome () {
      if (this.itemType) {
        this.$router.push({ name: this.itemType })
      } else { this.$router.push({ name: 'Playdates' }) }
    }
  }
}
