(function() {
  self.BasicRenderer = (function() {
    function BasicRenderer(container_div) {
      this.container_div = container_div;
    }
    BasicRenderer.prototype.renderThumbs = function(thumbs) {
      return $(thumbs).each(function(index, object) {
        return $('#thumbs').append("<img src=\"" + object + "\"/>");
      });
    };
    return BasicRenderer;
  })();
}).call(this);
