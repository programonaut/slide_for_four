'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  ".vscode/settings.json": "19751b2a32e46d1ba1477f357123a898",
"android-chrome-192x192.png": "7b60b468e8db6771f8a779027164ffa8",
"android-chrome-512x512.png": "26dc70e8564b92493db2432222e20177",
"apple-touch-icon.png": "88576851f48f857f126fbb9f50ae496d",
"assets/animations/circle.riv": "321a69c527e0d5a60526bef9c6292ac4",
"assets/animations/cross.riv": "cd1510ff51e7ce92d683b145bc21d4fd",
"assets/AssetManifest.json": "a629822439d744f5915067d19853fa49",
"assets/assets/images/field-circle-1.png": "34ab2839a8cada3452b65ad7bb549ada",
"assets/assets/images/field-circle-2.png": "7e9d2f3134fbe1c585bf8d8df1962b67",
"assets/assets/images/field-circle-3.png": "233f2db024ed47cf7e4ed044c22a5a7b",
"assets/assets/images/field-circle-4.png": "08202e1ce2573732c067c78ae2d885df",
"assets/assets/images/field-cross-1.png": "947feca55120ccdf73413352a7d7133e",
"assets/assets/images/field-cross-2.png": "3e271b8ad9aad74915415fc3e3dbbea7",
"assets/assets/images/field-cross-3.png": "8954558aec0a2b57efdb19c2c1fe8926",
"assets/assets/images/field-cross-4.png": "6b8f20e8c77155fcf6fb0075ac4656cf",
"assets/assets/images/field-navigation-do.png": "6482428e99706f405e680d56295ed538",
"assets/assets/images/field-navigation-le.png": "05c95b45264e71a75b2e6046af349e61",
"assets/assets/images/field-navigation-ri.png": "259fb6096dc7b23280c4484596e9b6b2",
"assets/assets/images/field-navigation-up.png": "c087fb72c79ddfff835a91f205a103bc",
"assets/assets/images/field-outline.png": "3e8cccc322fb859b752cf6fcc584d7e6",
"assets/assets/images/highlight.png": "db65f9831da93e72bb119fe6e2a1ccda",
"assets/assets/images/logo.png": "7853e7cd5847cf7d43258ee0acfb8c10",
"assets/assets/images/menu.png": "e324834d2ba1000a6d2ba46b9a7c5da0",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/NOTICES": "b7f1cfec0cf88693a3ead164bffb3130",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"browserconfig.xml": "a493ba0aa0b8ec8068d786d7248bb92c",
"canvaskit/canvaskit.js": "62b9906717d7215a6ff4cc24efbd1b5c",
"canvaskit/canvaskit.wasm": "b179ba02b7a9f61ebc108f82c5a1ecdb",
"canvaskit/profiling/canvaskit.js": "3783918f48ef691e230156c251169480",
"canvaskit/profiling/canvaskit.wasm": "6d1b0fc1ec88c3110db88caa3393c580",
"favicon-16x16.png": "d51b6ecd31859c17a6116b51682b05d5",
"favicon-32x32.png": "57c6d50433e5b09aec2036207303a477",
"favicon.ico": "08aa8d280b49036cf71e630ff0637540",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "28a84287908d588a0cc3e588f1f0b4cd",
"/": "28a84287908d588a0cc3e588f1f0b4cd",
"main.dart.js": "b0566eafcb9bf43223d1838f7df86824",
"manifest.json": "bf9320f3d5f8728aa857edd678bcbdb4",
"mstile-150x150.png": "917022cbf4218a4c1c569799f37eea3c",
"safari-pinned-tab.svg": "d816970e1a8ef9fe9802d3c33dd98481",
"site.webmanifest": "b39d2ba17ae52b359c40935bfd771e5c",
"version.json": "0ae39462c0d93348a145631b559c0f5f"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
