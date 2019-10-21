export default {
  data () {
    return {
      size: {
        innerWidth: window.innerWidth,
        innerHeight: window.innerHeight
      }
    }
  },
  computed: {
    // https://stackoverflow.com/questions/19689715/what-is-the-best-way-to-detect-retina-support-on-a-device-using-javascript
    isRetina () {
      return ((window.matchMedia && (window.matchMedia('only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx), only screen and (min-resolution: 75.6dpcm)').matches || window.matchMedia('only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 2/1), only screen and (min--moz-device-pixel-ratio: 2), only screen and (min-device-pixel-ratio: 2)').matches)) || (window.devicePixelRatio && window.devicePixelRatio >= 2)) && /(iPad|iPhone|iPod)/g.test(navigator.userAgent)
    },
    isTablet () {
      return this.size.innerWidth < 991 && this.size.innerWidth >= 767
    },
    isDesktop () {
      return this.size.innerWidth >= 991
    },
    isPhone () {
      return this.size.innerWidth < 767
    },
    isMobile () {
      return this.isPhone || this.isTablet
    }
  },
  methods: {
    handleResize: function () {
      this.size = {
        innerWidth: window.innerWidth,
        innerHeight: window.innerHeight
      }
    }
  },
  mounted: function () {
    this.handleResize()
    window.addEventListener('resize', this.handleResize)
  },
  beforeDestroy: function () {
    window.removeEventListener('resize', this.handleResize)
  }
}
