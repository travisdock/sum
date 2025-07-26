// Minimal Service Worker for Sum PWA
const CACHE_NAME = 'sum-v1';
const urlsToCache = [
  '/manifest.json',
  '/icon-192.png',
  '/icon-512.png'
];

// Install event - cache only manifest and icons
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
      .then(() => self.skipWaiting())
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames
          .filter(cacheName => cacheName !== CACHE_NAME)
          .map(cacheName => caches.delete(cacheName))
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch event - network first for everything except cached items
self.addEventListener('fetch', event => {
  const { request } = event;
  const url = new URL(request.url);
  
  // Only cache manifest and icons
  if (urlsToCache.includes(url.pathname)) {
    event.respondWith(
      caches.match(request)
        .then(response => response || fetch(request))
    );
  } else {
    // Everything else goes to network
    event.respondWith(fetch(request));
  }
});