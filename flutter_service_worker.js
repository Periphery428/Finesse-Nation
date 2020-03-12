'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/main.dart.js": "452c2c1f077f5feb7c630b8ba061678d",
"/manifest.json": "e635fd6dd182a2cf920db16d047ea5f3",
"/index.html": "f4e9d07268c4959f6f64e425712ec2e1",
"/assets/images/bemzo.jpg": "570492a60b67ca635d4c5015d4f8a5b3",
"/assets/images/icon.png": "eab05cba052275797e23bb7373ddf745",
"/assets/images/rem.png": "cbb0da3c829b27defb2bf3504eac6ee8",
"/assets/images/app_icon.png": "5f5244069ceba8559afa0a04f02321ef",
"/assets/images/rahbert.png": "98e5b6c34fa8cd40d5ada1e3deacb58d",
"/assets/images/oldsplash.png": "8d5c878eae66e827eadf0a05ee656c20",
"/assets/images/oldicon.png": "9090849005505bcd203a3b3b6ca8b841",
"/assets/images/photo_camera_black_288x288.png": "275d57df909d036c2ae1934171260e37",
"/assets/images/remram.png": "b5b8ffc328d2b85fd373a8b6e0e5a909",
"/assets/images/splash.png": "381f40776a410effed87d0fec5c27d91",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/FontManifest.json": "f7161631e25fbd47f3180eae84053a51",
"/assets/LICENSE": "ff6e14cef02d36bf547c102bdd8a1aed",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/AssetManifest.json": "0276492955c432c7e7d34deef5e0aa64"
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
