/* global importScripts firebase */

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
  const notificationOptions = {
    body: payload.data.body,
    icon: '/lilypad-icon-192x192.png',
    badge: '/lilypad-icon-192x192.png'
  }

  return self.registration.showNotification(notificationTitle,
    notificationOptions)
})
