'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/main.dart.js": "1ce27c2e670fc70d62d8d64529075b8b",
"/manifest.json": "e635fd6dd182a2cf920db16d047ea5f3",
"/index.html": "f4e9d07268c4959f6f64e425712ec2e1",
"/assets/images/bemzo.jpg": "570492a60b67ca635d4c5015d4f8a5b3",
"/assets/images/app_icon.png": "5f5244069ceba8559afa0a04f02321ef",
"/assets/images/rahbert.png": "98e5b6c34fa8cd40d5ada1e3deacb58d",
"/assets/images/remram.png": "b5b8ffc328d2b85fd373a8b6e0e5a909",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"/assets/LICENSE": "cae46c075412c628ddfc083c67a7cf9b",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/AssetManifest.json": "1488b1c8c65b7dfa45dacdb9ea306512"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
