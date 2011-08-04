(function() {
  self.AntiGallery = (function() {
    function AntiGallery(images_json) {
      this.images_json = images_json;
    }
    AntiGallery.prototype.renderWith = function(renderer) {
      this.renderer = renderer;
      return this.renderer;
    };
    return AntiGallery;
  })();
}).call(this);
