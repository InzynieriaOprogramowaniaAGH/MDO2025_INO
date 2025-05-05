/******/ (function() { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ({

/***/ 2652:
/***/ (function(__unused_webpack_module, __unused_webpack___webpack_exports__, __webpack_require__) {


// EXTERNAL MODULE: ./node_modules/lodash/debounce.js
var debounce = __webpack_require__(8221);
var debounce_default = /*#__PURE__*/__webpack_require__.n(debounce);
;// ./src/main/js/util/behavior-shim.js
function specify(selector, id, priority, behavior) {
  Behaviour.specify(selector, id, priority, behavior);
}
function applySubtree(startNode, includeSelf) {
  Behaviour.applySubtree(startNode, includeSelf);
}
/* harmony default export */ var behavior_shim = ({
  specify,
  applySubtree
});
;// ./src/main/js/pages/project/builds-card.js



// Card/item controls
const buildHistoryPage = document.getElementById("buildHistoryPage");
const pageSearch = buildHistoryPage.querySelector(".jenkins-search");
const pageSearchInput = buildHistoryPage.querySelector("input");
const ajaxUrl = buildHistoryPage.getAttribute("page-ajax");
const card = document.querySelector("#jenkins-builds");
const contents = card.querySelector("#jenkins-build-history");
const container = card.querySelector(".app-builds-container");
const loadingBuilds = card.querySelector("#loading-builds");
const noBuilds = card.querySelector("#no-builds");

// Pagination controls
const paginationControls = document.querySelector("#controls");
const paginationPrevious = document.querySelector("#up");
const paginationNext = document.querySelector("#down");

// Refresh variables
let buildRefreshTimeout;
const updateBuildsRefreshInterval = 5000;

/**
 * Refresh the 'Builds' card
 * @param {QueryParameters}  options
 */
function load() {
  let options = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  /** @type {QueryParameters} */
  cancelRefreshTimeout();
  const params = Object.assign({}, options, {
    search: pageSearchInput.value
  });
  const paginationOrFirst = buildHistoryPage.dataset.pageHasUp === "false" || "older-than" in params || "newer-than" in params;

  // Avoid fetching if the page isn't visible
  if (document.hidden) {
    return;
  }
  createRefreshTimeout();

  // When we're not on the first page and this is not a load due to pagination
  // we need to set the correct value for older-than so we fetch the same set of runs
  if (!paginationOrFirst) {
    params["older-than"] = (BigInt(buildHistoryPage.dataset.pageEntryNewest) + 1n).toString();
  }
  fetch(ajaxUrl + toQueryString(params)).then(rsp => {
    if (rsp.ok) {
      rsp.text().then(responseText => {
        container.classList.remove("app-builds-container--loading");
        pageSearch.classList.remove("jenkins-search--loading");

        // Show the 'No builds' text if there are no builds
        if (responseText.trim() === "") {
          contents.innerHTML = "";
          noBuilds.style.display = "block";
          loadingBuilds.style.display = "none";
          updateCardControls({
            pageHasUp: false,
            pageHasDown: false,
            pageEntryNewest: false,
            pageEntryOldest: false
          });
          return;
        }

        // Show the refreshed builds list
        contents.innerHTML = responseText;
        loadingBuilds.style.display = "none";
        behavior_shim.applySubtree(contents);

        // Show the card controls
        const div = document.createElement("div");
        div.innerHTML = responseText;
        const innerChild = div.children[0];
        updateCardControls({
          pageHasUp: innerChild.dataset.pageHasUp === "true",
          pageHasDown: innerChild.dataset.pageHasDown === "true",
          pageEntryNewest: innerChild.dataset.pageEntryNewest,
          pageEntryOldest: innerChild.dataset.pageEntryOldest
        });
      });
    } else {
      console.error("Failed to load 'Builds' card, response from API is:", rsp);
    }
  });
}

/**
 * Shows/hides the card's pagination controls depending on the passed parameter
 * @param {CardControlsOptions}  parameters
 */
function updateCardControls(parameters) {
  paginationControls.classList.toggle("jenkins-hidden", !parameters.pageHasUp && !parameters.pageHasDown);
  paginationPrevious.classList.toggle("app-builds-container__button--disabled", !parameters.pageHasUp);
  paginationNext.classList.toggle("app-builds-container__button--disabled", !parameters.pageHasDown);
  buildHistoryPage.dataset.pageEntryNewest = parameters.pageEntryNewest;
  buildHistoryPage.dataset.pageEntryOldest = parameters.pageEntryOldest;
  buildHistoryPage.dataset.pageHasUp = parameters.pageHasUp;
}
paginationPrevious.addEventListener("click", () => {
  load({
    "newer-than": buildHistoryPage.dataset.pageEntryNewest
  });
});
paginationNext.addEventListener("click", () => {
  load({
    "older-than": buildHistoryPage.dataset.pageEntryOldest
  });
});
function createRefreshTimeout() {
  cancelRefreshTimeout();
  buildRefreshTimeout = window.setTimeout(() => load(), updateBuildsRefreshInterval);
}
function cancelRefreshTimeout() {
  if (buildRefreshTimeout) {
    window.clearTimeout(buildRefreshTimeout);
    buildRefreshTimeout = undefined;
  }
}
const debouncedLoad = debounce_default()(() => {
  load();
}, 150);
document.addEventListener("DOMContentLoaded", function () {
  pageSearchInput.addEventListener("input", function () {
    container.classList.add("app-builds-container--loading");
    pageSearch.classList.add("jenkins-search--loading");
    debouncedLoad();
  });
  container.classList.add("app-builds-container--loading");
  load();
  window.addEventListener("focus", function () {
    load();
  });
});

/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = __webpack_modules__;
/******/ 	
/************************************************************************/
/******/ 	/* webpack/runtime/chunk loaded */
/******/ 	!function() {
/******/ 		var deferred = [];
/******/ 		__webpack_require__.O = function(result, chunkIds, fn, priority) {
/******/ 			if(chunkIds) {
/******/ 				priority = priority || 0;
/******/ 				for(var i = deferred.length; i > 0 && deferred[i - 1][2] > priority; i--) deferred[i] = deferred[i - 1];
/******/ 				deferred[i] = [chunkIds, fn, priority];
/******/ 				return;
/******/ 			}
/******/ 			var notFulfilled = Infinity;
/******/ 			for (var i = 0; i < deferred.length; i++) {
/******/ 				var chunkIds = deferred[i][0];
/******/ 				var fn = deferred[i][1];
/******/ 				var priority = deferred[i][2];
/******/ 				var fulfilled = true;
/******/ 				for (var j = 0; j < chunkIds.length; j++) {
/******/ 					if ((priority & 1 === 0 || notFulfilled >= priority) && Object.keys(__webpack_require__.O).every(function(key) { return __webpack_require__.O[key](chunkIds[j]); })) {
/******/ 						chunkIds.splice(j--, 1);
/******/ 					} else {
/******/ 						fulfilled = false;
/******/ 						if(priority < notFulfilled) notFulfilled = priority;
/******/ 					}
/******/ 				}
/******/ 				if(fulfilled) {
/******/ 					deferred.splice(i--, 1)
/******/ 					var r = fn();
/******/ 					if (r !== undefined) result = r;
/******/ 				}
/******/ 			}
/******/ 			return result;
/******/ 		};
/******/ 	}();
/******/ 	
/******/ 	/* webpack/runtime/compat get default export */
/******/ 	!function() {
/******/ 		// getDefaultExport function for compatibility with non-harmony modules
/******/ 		__webpack_require__.n = function(module) {
/******/ 			var getter = module && module.__esModule ?
/******/ 				function() { return module['default']; } :
/******/ 				function() { return module; };
/******/ 			__webpack_require__.d(getter, { a: getter });
/******/ 			return getter;
/******/ 		};
/******/ 	}();
/******/ 	
/******/ 	/* webpack/runtime/define property getters */
/******/ 	!function() {
/******/ 		// define getter functions for harmony exports
/******/ 		__webpack_require__.d = function(exports, definition) {
/******/ 			for(var key in definition) {
/******/ 				if(__webpack_require__.o(definition, key) && !__webpack_require__.o(exports, key)) {
/******/ 					Object.defineProperty(exports, key, { enumerable: true, get: definition[key] });
/******/ 				}
/******/ 			}
/******/ 		};
/******/ 	}();
/******/ 	
/******/ 	/* webpack/runtime/global */
/******/ 	!function() {
/******/ 		__webpack_require__.g = (function() {
/******/ 			if (typeof globalThis === 'object') return globalThis;
/******/ 			try {
/******/ 				return this || new Function('return this')();
/******/ 			} catch (e) {
/******/ 				if (typeof window === 'object') return window;
/******/ 			}
/******/ 		})();
/******/ 	}();
/******/ 	
/******/ 	/* webpack/runtime/hasOwnProperty shorthand */
/******/ 	!function() {
/******/ 		__webpack_require__.o = function(obj, prop) { return Object.prototype.hasOwnProperty.call(obj, prop); }
/******/ 	}();
/******/ 	
/******/ 	/* webpack/runtime/runtimeId */
/******/ 	!function() {
/******/ 		__webpack_require__.j = 68;
/******/ 	}();
/******/ 	
/******/ 	/* webpack/runtime/jsonp chunk loading */
/******/ 	!function() {
/******/ 		// no baseURI
/******/ 		
/******/ 		// object to store loaded and loading chunks
/******/ 		// undefined = chunk not loaded, null = chunk preloaded/prefetched
/******/ 		// [resolve, reject, Promise] = chunk loading, 0 = chunk loaded
/******/ 		var installedChunks = {
/******/ 			68: 0
/******/ 		};
/******/ 		
/******/ 		// no chunk on demand loading
/******/ 		
/******/ 		// no prefetching
/******/ 		
/******/ 		// no preloaded
/******/ 		
/******/ 		// no HMR
/******/ 		
/******/ 		// no HMR manifest
/******/ 		
/******/ 		__webpack_require__.O.j = function(chunkId) { return installedChunks[chunkId] === 0; };
/******/ 		
/******/ 		// install a JSONP callback for chunk loading
/******/ 		var webpackJsonpCallback = function(parentChunkLoadingFunction, data) {
/******/ 			var chunkIds = data[0];
/******/ 			var moreModules = data[1];
/******/ 			var runtime = data[2];
/******/ 			// add "moreModules" to the modules object,
/******/ 			// then flag all "chunkIds" as loaded and fire callback
/******/ 			var moduleId, chunkId, i = 0;
/******/ 			if(chunkIds.some(function(id) { return installedChunks[id] !== 0; })) {
/******/ 				for(moduleId in moreModules) {
/******/ 					if(__webpack_require__.o(moreModules, moduleId)) {
/******/ 						__webpack_require__.m[moduleId] = moreModules[moduleId];
/******/ 					}
/******/ 				}
/******/ 				if(runtime) var result = runtime(__webpack_require__);
/******/ 			}
/******/ 			if(parentChunkLoadingFunction) parentChunkLoadingFunction(data);
/******/ 			for(;i < chunkIds.length; i++) {
/******/ 				chunkId = chunkIds[i];
/******/ 				if(__webpack_require__.o(installedChunks, chunkId) && installedChunks[chunkId]) {
/******/ 					installedChunks[chunkId][0]();
/******/ 				}
/******/ 				installedChunks[chunkId] = 0;
/******/ 			}
/******/ 			return __webpack_require__.O(result);
/******/ 		}
/******/ 		
/******/ 		var chunkLoadingGlobal = self["webpackChunkjenkins_ui"] = self["webpackChunkjenkins_ui"] || [];
/******/ 		chunkLoadingGlobal.forEach(webpackJsonpCallback.bind(null, 0));
/******/ 		chunkLoadingGlobal.push = webpackJsonpCallback.bind(null, chunkLoadingGlobal.push.bind(chunkLoadingGlobal));
/******/ 	}();
/******/ 	
/******/ 	/* webpack/runtime/nonce */
/******/ 	!function() {
/******/ 		__webpack_require__.nc = undefined;
/******/ 	}();
/******/ 	
/************************************************************************/
/******/ 	
/******/ 	// startup
/******/ 	// Load entry module and return exports
/******/ 	// This entry module depends on other loaded chunks and execution need to be delayed
/******/ 	var __webpack_exports__ = __webpack_require__.O(undefined, [96], function() { return __webpack_require__(2652); })
/******/ 	__webpack_exports__ = __webpack_require__.O(__webpack_exports__);
/******/ 	
/******/ })()
;
//# sourceMappingURL=builds-card.js.map