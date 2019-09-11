/* this is run in the context of the service worker which defines variable */
/* eslint-disable no-undef */
importScripts('https://storage.googleapis.com/workbox-cdn/releases/4.3.1/workbox-sw.js')

if (workbox) {
  // chill on the logs, workbox
  workbox.setConfig({ debug: false })

  workbox.routing.registerRoute(
    /^\/api\//,
    new workbox.strategies.NetworkFirst({
      cacheName: 'api'
    })
  )

  workbox.routing.registerRoute(
    /\.js$/,
    new workbox.strategies.NetworkFirst({
      cacheName: 'javascript'
    })
  )
  workbox.routing.registerRoute(
  // Cache CSS files.
    /\.css$/,
    // Use cache but update in the background.
    new workbox.strategies.StaleWhileRevalidate({
      cacheName: 'css-cache'
    })
  )

  workbox.routing.registerRoute(
  // Cache image files.
    /\.(?:png|jpg|jpeg|svg|gif)$/,
    // Use the cache if it's available.
    new workbox.strategies.CacheFirst({
    // Use a custom cache name.
      cacheName: 'image-cache',
      plugins: [
        new workbox.expiration.Plugin({
        // Cache only 20 images.
          maxEntries: 20,
          // Cache for a maximum of a week.
          maxAgeSeconds: 7 * 24 * 60 * 60
        })
      ]
    })
  )

  self.addEventListener('push', function (e) {
    var body

    if (e.data) {
      body = e.data.text()
    } else {
      body = 'Push message no payload'
    }

    var options = {
      body: body,
      icon: 'images/notification-flat.png',
      vibrate: [100, 50, 100],
      data: {
        dateOfArrival: Date.now(),
        primaryKey: 1
      },
      actions: [
        { action: 'explore',
          title: 'Explore this new world',
          icon: 'images/checkmark.png' },
        { action: 'close',
          title: 'I don\'t want any of this',
          icon: 'images/xmark.png' }
      ]
    }
    e.waitUntil(
      self.registration.showNotification('Push Notification', options)
    )
  })
} else {
  console.log(`Boo! Workbox didn't load 😬`)
}
