import Logger from '@/utils/logger'

export default {
  data () {
    return {
      mixinLogger: null
    }
  },
  created () {
    this.mixinLogger = Logger(this.$options.name)
  },
  methods: {
    log (msg) {
      this.mixinLogger.log(msg)
    },
    error (msg) {
      this.mixinLogger.error(msg)
    },
    debug (msg) {
      this.mixinLogger.debug(msg)
    }
  }
}
