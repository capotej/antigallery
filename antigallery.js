(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  self.AntiGallery = (function() {
    function AntiGallery(images) {
      this.images = images;
      this.currentIndex = 0;
      this.currentThumbIndex = 0;
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
      return button.click(__bind(function(evt) {
        evt.preventDefault();
        return this.nextImage();
      }, this));
    };
    AntiGallery.prototype.registerPrevious = function(button) {
      return button.click(__bind(function(evt) {
        evt.preventDefault();
        return this.previousImage();
      }, this));
    };
    AntiGallery.prototype.registerThumbClick = function(button) {
      return button.click(__bind(function(evt) {
        var index;
        evt.preventDefault();
        index = $(evt.target).data(this.renderer.thumbIndexName());
        return this.setImageAndIndex(index);
      }, this));
    };
    AntiGallery.prototype.setImageAndIndex = function(index) {
      this.currentIndex = index;
      return this.renderer.renderMainImage(this.imageForIndex(index));
    };
    AntiGallery.prototype.imageForIndex = function(index) {
      return this.stripFull(this.images[index]);
    };
    AntiGallery.prototype.nextImage = function() {
      this.currentIndex += 1;
      if (this.currentIndex > this.images.length - 1) {
        this.currentIndex = 0;
      }
      return this.renderer.renderMainImage(this.imageForIndex(this.currentIndex));
    };
    AntiGallery.prototype.previousImage = function() {
      if (this.currentIndex === 0) {
        this.currentIndex = this.images.length - 1;
      } else {
        this.currentIndex -= 1;
      }
      return this.renderer.renderMainImage(this.imageForIndex(this.currentIndex));
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
      this.rendererCallbacks(this.renderer);
      return this.registerEvents();
    };
    AntiGallery.prototype.rendererCallbacks = function() {
      this.renderer.renderMainImage(this.firstImage());
      return this.renderer.renderThumbs(this.thumbs());
    };
    AntiGallery.prototype.registerEvents = function() {
      this.registerPrevious(this.renderer.previousButton());
      this.registerNext(this.renderer.nextButton());
      return this.registerThumbClick(this.renderer.thumbElement());
    };
    return AntiGallery;
  })();
}).call(this);