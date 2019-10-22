import { mapGetters } from 'vuex'

import { isIOSNativeApp } from '@/utils/platform'

export default {
  data () {
    return {
    }
  },
  computed: {
    showBackButtonInMainNav () {
      return isIOSNativeApp() &&
        this.$route.name !== 'Events' &&
        this.$route.name !== 'Parents' &&
        this.previousRouteExists
    },
    previousRouteExists () {
      return !!this.previousPath
    },
    ...mapGetters(['previousPath'])
  },
  methods: {
  }
}
