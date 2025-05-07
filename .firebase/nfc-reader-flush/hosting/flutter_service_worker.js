'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "e78a87a6e7625c05da90997baa6c8114",
"assets/AssetManifest.bin.json": "3c334a1294aefe78aa85fe2b63051688",
"assets/AssetManifest.json": "2507367c28b6bed564bc794a747dbf00",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "7e7b19a0d953ff1942a95a3ef7e6d11c",
"assets/images/animations/splash.json": "56f738fa96bc620c8114b740e6f69760",
"assets/images/cover_img.jpg": "b491de8955297b49abc3b5c40feefbfc",
"assets/images/ic_add_pics.png": "e35117b4f2c1d52bc6ba0e879885ef17",
"assets/images/ic_arrow_right.png": "0370274d84ea7f1dd69365a363938358",
"assets/images/ic_avatar_default.png": "35204c49bcc0f30c9faa65c3191dbb43",
"assets/images/ic_comment.png": "43fb79ea6af631d20dcbbe0e58bd05af",
"assets/images/ic_discover_gist.png": "2765de5b5d83f40f3780a2ac87a05e83",
"assets/images/ic_discover_git.png": "49f0255e43372ebc6811e6fb9fe43f21",
"assets/images/ic_discover_nearby.png": "0907f715c4bf90e2db7e495478c8014b",
"assets/images/ic_discover_pos.png": "766830401828678e1e11b82344a6213a",
"assets/images/ic_discover_scan.png": "f14373414ec03c77da611956552653d8",
"assets/images/ic_discover_shake.png": "664f8b09b56bea66e000a78ffebaaed3",
"assets/images/ic_discover_softwares.png": "721f42b2351a4ee92671b87678a8bc9d",
"assets/images/ic_hongshu.jpg": "74342422815084c4a40d9ef9a55a5ce5",
"assets/images/ic_img_default.jpg": "8b0703ba049cad1ec2c339bc92939e41",
"assets/images/ic_my_blog.png": "6e3cf29187fa8249e7cc972e4eabd787",
"assets/images/ic_my_message.png": "cb597f79147cc3ed42dca4bb6730d823",
"assets/images/ic_my_question.png": "57cbc24fdb006d98d6149907fd15b01e",
"assets/images/ic_my_recommend.png": "536cec447c90fef48f000b18c0fbf436",
"assets/images/ic_my_team.png": "ba9d6e7b78f342fad28d618beca0f7ee",
"assets/images/ic_nav_discover_actived.png": "203dce21d8a4dc58211ac4ad787e75de",
"assets/images/ic_nav_discover_normal.png": "9e2960977d86ca73ab28365f2b561819",
"assets/images/ic_nav_my_normal.png": "6c6b8b9c10c76b3babb5c6147fc2df75",
"assets/images/ic_nav_my_pressed.png": "0014443a4a6fccefa7b716e56e96e0b1",
"assets/images/ic_nav_news_actived.png": "ea3663f7e53819c46769b27a80e0a11c",
"assets/images/ic_nav_news_normal.png": "ffdddc11315fc9b3e9517b1fc667505f",
"assets/images/ic_nav_tweet_actived.png": "c17af9a937a0c641dc7623e53bfd41e2",
"assets/images/ic_nav_tweet_normal.png": "896dd1b9654d3fc7cb94602b7c6a298c",
"assets/images/ic_osc_logo.png": "3d1b2178fb5c71bcc139e64b05fd3398",
"assets/images/ic_test.png": "8c2efa29920e6c2e0017964fd829a1f6",
"assets/images/leftmenu/ic_about.png": "636a452085e2c332a4c71911e6a85c8f",
"assets/images/leftmenu/ic_fabu.png": "ae6679e96d5cfbb2f5e92546869c553d",
"assets/images/leftmenu/ic_settings.png": "f5f1d1dc4c1737305d7089d46dd996bf",
"assets/images/leftmenu/ic_xiaoheiwu.png": "ae65dd6706611d78533382bcab005037",
"assets/NOTICES": "0324dbddb60e7aa8e89a3aa645f13330",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "10008dbc98d0c35b42bac9cd9f0c337c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "40dc38ed86bce2cdfd8d836d66964287",
"/": "40dc38ed86bce2cdfd8d836d66964287",
"main.dart.js": "89195dfde87d425e8117fdb48acb6656",
"manifest.json": "e6e2bc110b075cf6b200e703fca7c8c1",
"version.json": "ef57a98a2e80df732707074b989253c2"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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
