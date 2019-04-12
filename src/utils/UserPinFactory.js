export default function (google) {
  function UserPin (position, map, el) {
    this.latlng = new google.maps.LatLng(position.lat, position.lng)
    this.setMap(map)
    this.el = el
  }

  UserPin.prototype = new google.maps.OverlayView()

  UserPin.prototype.draw = function () {
    var self = this
    google.maps.event.addDomListener(self.el, 'click', function (event) {
      google.maps.event.trigger(self, 'click')
    })

    var panes = this.getPanes()
    panes.overlayImage.appendChild(self.el)

    var point = this.getProjection().fromLatLngToDivPixel(this.latlng)
    if (point) {
      self.el.style.left = point.x + 'px'
      self.el.style.top = point.y + 'px'
    }
  }

  UserPin.prototype.remove = function () {
    if (this.el) {
      this.el.parentNode.removeChild(this.el)
      this.el = null
    }
  }

  UserPin.prototype.getPosition = function () {
    return this.latlng
  }

  return UserPin
}
