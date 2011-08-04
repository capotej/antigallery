(function() {
  self.AntiGallery = (function() {
    function AntiGallery(images) {
      this.images = images;
    }
    AntiGallery.prototype.stripThumb = function(image) {
      return image.thumb;
    };
    AntiGallery.prototype.thumbs = function() {
      var image, _i, _len, _ref, _results;
      _ref = this.images;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        image = _ref[_i];
        _results.push(this.stripThumb(image));
      }
      return _results;
    };
    AntiGallery.prototype.renderWith = function(renderer) {
      this.renderer = renderer;
      return this.renderer.renderThumbs(this.thumbs());
    };
    return AntiGallery;
  })();
}).call(this);
