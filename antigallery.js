(function() {
  self.AntiGallery = (function() {
    function AntiGallery(images) {
      this.images = images;
    }
    AntiGallery.prototype.stripThumb = function(image) {
      return image.thumb;
    };
    AntiGallery.prototype.stripFull = function(image) {
      return image.full;
    };
    AntiGallery.prototype.firstImage = function() {
      return this.stripFull(this.images[0]);
    };
    AntiGallery.prototype.registerNext = function(button) {
      return button.click(function(evt) {
        evt.preventDefault();
        return this.nextImage();
      });
    };
    AntiGallery.prototype.registerPrevious = function(button) {
      return button.click(function(evt) {
        evt.preventDefault();
        return this.previousImage();
      });
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
      this.registerPrevious(this.renderer.previousButton());
      this.registerNext(this.renderer.nextButton());
      this.renderer.nextButton;
      this.renderer.renderMainImage(this.firstImage());
      return this.renderer.renderThumbs(this.thumbs());
    };
    return AntiGallery;
  })();
}).call(this);
