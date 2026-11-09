importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "ISI_API_KEY_KAMU",
  authDomain: "ISI_AUTH_DOMAIN_KAMU",
  projectId: "ISI_PROJECT_ID_KAMU",
  storageBucket: "ISI_STORAGE_BUCKET_KAMU",
  messagingSenderId: "ISI_MESSAGING_SENDER_ID_KAMU",
  appId: "ISI_APP_ID_KAMU"
});

const messaging = firebase.messaging();