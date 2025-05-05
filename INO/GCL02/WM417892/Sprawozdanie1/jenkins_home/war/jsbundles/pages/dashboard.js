/******/ (function() { // webpackBootstrap
/******/ 	"use strict";

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
;// ./src/main/js/util/dom.js
function createElementFromHtml(html) {
  const template = document.createElement("template");
  template.innerHTML = html.trim();
  return template.content.firstElementChild;
}
function toId(string) {
  return string.trim().replace(/[\W_]+/g, "-").toLowerCase();
}
;// ./src/main/js/pages/dashboard/index.js


behavior_shim.specify("#button-icon-legend", "icon-legend", 999, button => {
  button.addEventListener("click", () => {
    const template = document.querySelector("#template-icon-legend");
    const title = template.getAttribute("data-title");
    const content = createElementFromHtml("<div>" + template.innerHTML + "</div>");
    dialog.modal(content, {
      maxWidth: "550px",
      title: title
    });
  });
});
/******/ })()
;
//# sourceMappingURL=dashboard.js.map