(function() {
  self.BasicRenderer = (function() {
    function BasicRenderer(container_div) {
      this.container_div = container_div;
    }
    BasicRenderer.prototype.container = function() {
      return $("#" + this.container_div);
    };
    BasicRenderer.prototype.renderThumbs = function(thumbs) {
      return $(thumbs).each(function(index, object) {
        return $('#thumbs').append("<img src=\"" + object + "\"/>");
      });
    };
    BasicRenderer.prototype.renderMainImage = function(image) {
      return $('#main_image').empty().append("<img src=\"" + image + "\"/>");
    };
    BasicRenderer.prototype.select = function(sel) {
      return $(sel, this.container());
    };
    BasicRenderer.prototype.nextButton = function() {
      return this.select("#next");
    };
    BasicRenderer.prototype.previousButton = function() {
      return this.select('#prev');
    };
    return BasicRenderer;
  })();
}).call(this);
