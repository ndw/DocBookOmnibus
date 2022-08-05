window.onload = function() {
  const defeatTheCache = new Date();
  SaxonJS.transform({
    stylesheetLocation: `xslt/omnibus.sef.json?nocache=${defeatTheCache.getTime()}`,
    sourceLocation: `index.html?nocache=${defeatTheCache.getTime()}`
  }, "async");
};

// Derived from 01-nav.js in https://github.com/asciidoctor/asciidoctor-docs-ui/
(function () {
  'use strict';

  var navContainer = document.querySelector('.sitenav');

  var nav = navContainer.querySelector('.nav');
  var navBounds = { encroachingElement: document.querySelector('#om_pagefooter') };

  window.addEventListener('load', fitNavInit);   /* needed if images shift the content */
  window.addEventListener('resize', fitNavInit);

  fitNavInit({});

  function trapEvent (e) {
    e.stopPropagation();
  }

  function fitNavInit (e) {
    window.removeEventListener('scroll', fitNav);
    if (window.getComputedStyle(navContainer).position === 'fixed') {
      return;
    }
    navBounds.availableHeight = window.innerHeight;
    navBounds.preferredHeight = navContainer.getBoundingClientRect().height;
    window.addEventListener('scroll', fitNav);
  }

  function fitNav () {
    var occupied = navBounds.availableHeight
        - navBounds.encroachingElement.getBoundingClientRect().top;
    if (occupied > 0) {
      let calcHeight = Math.max(Math.round(navBounds.preferredHeight - occupied), 0) + 'px';
      return nav.style.height !== (nav.style.height = calcHeight);
    } else {
      return !!nav.style.removeProperty('height');
    }
  }
})();
