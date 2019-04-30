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
    logError (msg) {
      this.mixinLogger.logError(msg)
    },
    debug (msg) {
      this.mixinLogger.debug(msg)
    }
  }
}
