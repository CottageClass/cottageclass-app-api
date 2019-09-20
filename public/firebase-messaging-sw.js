/* global importScripts firebase clients */

importScripts('https://www.gstatic.com/firebasejs/6.3.4/firebase-app.js')
importScripts('https://www.gstatic.com/firebasejs/6.3.4/firebase-messaging.js')

firebase.initializeApp({
  'messagingSenderId': '438514874280'
})

const messaging = firebase.messaging()
messaging.setBackgroundMessageHandler(function (payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload)
  // Customize notification here
  const notificationTitle = payload.data.title
  // these are in the 'notification' object used in the event handler below
  const notificationOptions = {
    body: payload.data.body,
    data: payload.data,
    icon: payload.data.icon,
    badge: '/lilypad-icon-monochrome-72x72.png'
  }

  return self.registration.showNotification(notificationTitle,
    notificationOptions)
})

self.addEventListener('notificationclick', function (e) {
  if (e.action !== 'close') {
    try {
      clients.openWindow(e.notification.data.url)
    } catch (e) {
      throw Error('there was a problem opening the page')
    }
  }
  e.notification.close()
})
