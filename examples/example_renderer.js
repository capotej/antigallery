(function() {
  /*
  
  # Example Renderer
  
  This defines a basic renderer for use with antigallery. All callbacks mandatory unless stated otherwise.
  
  */  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  self.ExampleRenderer = (function() {
    function ExampleRenderer(container_div) {
      this.container_div = container_div;
      /*
          (Optional) You can get creative here with your own constructor, but ours will just take a div id.
          */
    }
    ExampleRenderer.prototype.paginateThreshold = 5;
    /*
        When to paginate
        */
    ExampleRenderer.prototype.container = function() {
      /*
          (Optional) Convinience function for returning a jquery object of the container div
          */      return $("#" + this.container_div);
    };
    ExampleRenderer.prototype.select = function(sel) {
      /*
          (Optional) Convinience function for returning a jquery selector scoped to a container
          */      return $(sel, this.container());
    };
    ExampleRenderer.prototype.thumbIndexName = function() {
      /*
          The name of the data element that holds the thumb index (how configurable is that?!)
          */      return "thumb-index";
    };
    ExampleRenderer.prototype.thumbSetIndexName = function() {
      /*
          The name of the data element that holds the thumbset index
          */      return "thumbset-index";
    };
    ExampleRenderer.prototype.renderThumbs = function(thumbs) {
      /*
          Takes an array of thumb urls (paged by paginatedThreshold), expects to be drawn with an index
          */      this.select('#thumbs').empty();
      return $(thumbs).each(__bind(function(index, url) {
        return this.select('#thumbs').append("<img class=\"thumb\" src=\"" + url + "\" data-thumb-index=\"" + index + "\"/>");
      }, this));
    };
    ExampleRenderer.prototype.renderNavForPages = function(length) {
      /*
          Takes a length, its up to you to draw the numbers and link them, uses thumbSetIndexName to find the index
          */      var i, _results;
      _results = [];
      for (i = 0; 0 <= length ? i < length : i > length; 0 <= length ? i++ : i--) {
        _results.push(this.select('#page_nav').append("<li class=\"page\" data-thumbset-index=\"" + i + "\">Page</li>"));
      }
      return _results;
    };
    ExampleRenderer.prototype.setActiveThumb = function(index) {
      /*
          Takes the index of the currently displayed image, used for styling the active thumb
          */      this.select("#thumbs img").css('border', '0px solid black');
      return this.select("#thumbs img[data-thumb-index=\"" + index + "\"]").css('border', '1px solid black');
    };
    ExampleRenderer.prototype.renderMainImage = function(image) {
      /*
          Takes a full image url, called on page load, during prev/next, and when a thumb is clicked
          */      return this.select('#main_image').empty().append("<img src=\"" + image + "\"/>");
    };
    ExampleRenderer.prototype.nextButton = function() {
      /*
          Needs to return a scoped selector to that gallerys next button
          */      return this.select("#next");
    };
    ExampleRenderer.prototype.previousButton = function() {
      /*
          Needs to return a scoped selector to that gallerys previous button
          */      return this.select('#prev');
    };
    ExampleRenderer.prototype.nextPageButton = function() {
      /*
          Needs to return a scoped selector to that gallerys next thumbset button
          */      return this.select("#next_thumb");
    };
    ExampleRenderer.prototype.previousPageButton = function() {
      /*
          Needs to return a scoped selector to that gallerys previous thumbset button
          */      return this.select('#prev_thumb');
    };
    ExampleRenderer.prototype.thumbElement = function() {
      /*
          Needs to return a scoped selector to all of the thumb img elements for the gallery
          */      return this.select('.thumb');
    };
    ExampleRenderer.prototype.pageElement = function() {
      /*
          Needs to return a scoped selector to all of the thumb img elements for the gallery
          */      return this.select('.page');
    };
    return ExampleRenderer;
  })();
}).call(this);
