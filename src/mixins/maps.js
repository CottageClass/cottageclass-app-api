// A handy place to store utility functions for any page with a map
import GoogleMapsLoader from 'google-maps'
import Vue from 'vue'

export default {
  data () {
    return {
      map: null,
      google: null
    }
  },
  computed: {
    circlePath () {
      return async function (center, radius, numPoints) {
        center = { lat: parseFloat(center.lat), lng: parseFloat(center.lng) }
        numPoints = numPoints || 80
        const d2r = Math.PI / 180
        const circleLatLngs = []
        const circleLat = radius * 0.014483
        const circleLng = circleLat / Math.cos(center.lat * d2r)
        for (var i = 0; i < numPoints + 1; i++) {
          var theta = Math.PI * (i / (numPoints / 2))
          var vertexLat = center.lat + (circleLat * Math.sin(theta))
          var vertexLng = center.lng + (circleLng * Math.cos(theta))
          var vertextLatLng = await this.latlng(vertexLat, vertexLng)
          circleLatLngs.push(vertextLatLng)
        }
        return circleLatLngs
      }
    }
  },
  methods: {
    async createMap (element, options) {
      const google = await this.google
      this.map = new Promise(async function (resolve, reject) {
        const map = new google.maps.Map(element, options)
        resolve(map)
      })
      return this.map
    },
    async addCircle (center, radius) {
      await this.map
      const polygonOptions = {
        paths: await this.circlePath(center, radius),
        strokeColor: '#FF0000',
        strokeOpacity: 0.3,
        strokeWeight: 2,
        fillColor: '#FF0000',
        fillOpacity: 0.25,
        map: await this.map
      }
      const google = await this.google
      return new google.maps.Polygon(polygonOptions)
    },
    async zoomLevelForScale (metersPerPixel) {
      const map = await this.map
      const lat = map.center.lat()
      return Math.log2(156543.03392 * Math.cos(lat * Math.PI / 180) / metersPerPixel)
    },
    async latlng (lat, lng) {
      const google = await this.google
      return new google.maps.LatLng(parseFloat(lat), parseFloat(lng))
    }
  },
  mounted () {
    const googlePromise = new Promise((resolve, reject) => {
      GoogleMapsLoader.load(function (google) {
        resolve(google)
      })
    })
    this.google = googlePromise
  }
}
