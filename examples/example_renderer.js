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
    ExampleRenderer.prototype.renderThumbs = function(thumbs) {
      /*
          Takes an array of thumb urls, expects them to be drawn to the dom with a data attribute containing the index
          */      return $(thumbs).each(__bind(function(index, object) {
        return this.select('#thumbs').append("<img class=\"thumb\" src=\"" + object + "\" data-thumb-index=\"" + index + "\"/>");
      }, this));
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
    ExampleRenderer.prototype.thumbElement = function() {
      /*
          Needs to return a scoped selector to all of the thumb img elements for the gallery
          */      return this.select('.thumb');
    };
    return ExampleRenderer;
  })();
}).call(this);
