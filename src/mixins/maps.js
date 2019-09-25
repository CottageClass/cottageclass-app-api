// A handy place to store utility functions for any page with a map
import GoogleMapsLoader from 'google-maps'
import placeholder from '@/assets/avatar-placeholder.png'
import UserPinFactory from '@/utils/UserPinFactory'
import Marker from '@/components/base/UserPinMapMarker'

import Vue from 'vue'

let UserPin

const GMAPS_ZOOM_FACTOR = 156543.03392
const METERS_PER_MILE = 1609.34

export default {
  data () {
    return {
      map: null,
      google: null,
      element: null
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
    },
    userMarker () {
      return function (user) {
        var MarkerClass = Vue.extend(Marker)
        var instance = new MarkerClass({
          propsData: { avatarUrl: this.avatarUrl(user) }
        })
        instance.$mount()
        return instance
      }
    }
  },
  methods: {
    async createMap (element, options, idleHandler = null) {
      this.element = element
      const google = await this.google
      this.map = new Promise(async function (resolve, reject) {
        const map = new google.maps.Map(element, options)
        resolve(map)
      })
      if (idleHandler) {
        google.maps.event.addListener(await this.map, 'idle', idleHandler)
      }
      return this.map
    },
    avatarUrl (user) {
      if (user) {
        if (user.avatar) {
          return user.avatar
        } else if (user.facebookUid) {
          return 'https://graph.facebook.com/' + user.facebookUid + '/picture?width=200'
        } else {
          return placeholder
        }
      } else {
        return placeholder
      }
    },
    async addLilypadPin (position) {
      const MarkerClass = Vue.extend(Marker)
      const instance = new MarkerClass({
        propsData: { avatarUrl: 'https://joinlilypad.com/icons/android-chrome-192x192.png' }
      })
      instance.$mount()
      return this.addPin(instance.$el, position)
    },
    async addUserPin (user, position) {
      return this.addPin(this.userMarker(user).$el, position)
    },
    async addPin (el, position) {
      return new UserPin(position, await this.map, el)
    },
    async addCircle (center, radius) {
      await this.map
      const polygonOptions = {
        paths: await this.circlePath(center, radius),
        strokeWeight: 0,
        fillColor: '#FF0000',
        fillOpacity: 0.25,
        map: await this.map
      }
      const google = await this.google
      return new google.maps.Polygon(polygonOptions)
    },
    async zoomLevelForScale (metersPerPixel) {
      const lat = this.mapArea.center.lat
      return Math.log2(GMAPS_ZOOM_FACTOR * Math.cos(lat * Math.PI / 180) / metersPerPixel)
    },
    async scaleForZoomLevel (zoomLevel) {
      const map = await this.map
      const lat = map.center.lat()
      return GMAPS_ZOOM_FACTOR * Math.cos(lat * Math.PI / 180) / Math.pow(2, zoomLevel)
    },
    async latlng (lat, lng) {
      const google = await this.google
      return new google.maps.LatLng(parseFloat(lat), parseFloat(lng))
    },
    async radiusFromMap () {
      const map = await this.map
      const halfDiagonal = Math.hypot(this.element.clientHeight, this.element.clientWidth) / 2
      const scale = await this.scaleForZoomLevel(map.zoom) // in meters per pixel
      return halfDiagonal * scale / METERS_PER_MILE
    },
    zoomLevelForRadius: async function (radius) {
      const mapEl = document.querySelector('.map-container')
      const halfDiagonal = Math.hypot(mapEl.clientHeight, mapEl.clientWidth) / 2
      const desiredMetersPerPixel = radius * METERS_PER_MILE / halfDiagonal
      let zoom = Math.floor(await this.zoomLevelForScale(desiredMetersPerPixel))
      return Math.min(Math.max(zoom, 0), 20) // ensure it's in the range of acceptable zooms
    },
    setZoomLevelForRadius: async function (radius) {
      const map = await this.map
      map.setZoom(this.zoomLevelForRadius(radius))
    }
  },
  mounted () {
    const googlePromise = new Promise((resolve, reject) => {
      GoogleMapsLoader.load(function (google) {
        resolve(google)
        UserPin = UserPinFactory(google)
      })
    })
    this.google = googlePromise
  }
}
