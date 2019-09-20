/* global importScripts workbox */
/* this is run in the context of the service worker which defines variable */
importScripts('https://storage.googleapis.com/workbox-cdn/releases/4.3.1/workbox-sw.js')

// This is repsonsible for managing offline resources via workbox
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
} else {
  console.log(`Boo! Workbox didn't load 😬`)
}