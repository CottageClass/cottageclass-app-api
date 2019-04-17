// A handy place to store utility functions for any page with a map
import GoogleMapsLoader from 'google-maps'
import placeholder from '@/assets/avatar-placeholder.png'
import UserPinFactory from '@/utils/UserPinFactory'
import Marker from '@/components/base/UserPinMapMarker'

import Vue from 'vue'

let UserPin

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
    },
    marker () {
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
    async addUserPin (user, position) {
      const res = new UserPin(position, await this.map, this.marker(user).$el)
      return res
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
        UserPin = UserPinFactory(google)
      })
    })
    this.google = googlePromise
  }
}
