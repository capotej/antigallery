(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  self.AntiGallery = (function() {
    function AntiGallery(images) {
      var image;
      this.images = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = images.length; _i < _len; _i++) {
          image = images[_i];
          _results.push(this.tagImage(image, _i));
        }
        return _results;
      }).call(this);
      this.currentIndex = 0;
      this.currentThumbIndex = 0;
    }
    AntiGallery.prototype.tagImage = function(image, i) {
      image.id = i;
      return image;
    };
    AntiGallery.prototype.overThreshold = function() {
      return this.images.length > this.renderer.paginateThreshold;
    };
    AntiGallery.prototype.divideImages = function() {
      var arr, sub_arr;
      arr = [];
      sub_arr = [];
      $(this.images).each(__bind(function(index, image) {
        index = index + 1;
        sub_arr.push(image);
        if (index % this.renderer.paginateThreshold === 0) {
          arr.push(sub_arr);
          return sub_arr = [];
        }
      }, this));
      return arr;
    };
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
    AntiGallery.prototype.registerThumbNext = function(button) {
      return button.click(__bind(function(evt) {
        evt.preventDefault();
        return this.nextImage();
      }, this));
    };
    AntiGallery.prototype.registerThumbPrevious = function(button) {
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
    AntiGallery.prototype.extractThumbs = function(set) {
      var image, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = set.length; _i < _len; _i++) {
        image = set[_i];
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
      if (!this.overThreshold()) {
        this.thumbs = [this.images];
      } else {
        this.thumbs = this.divideImages();
      }
      this.renderer.renderMainImage(this.firstImage());
      return this.renderer.renderThumbs(this.thumbs[this.currentThumbIndex]);
    };
    AntiGallery.prototype.registerEvents = function() {
      this.registerPrevious(this.renderer.previousButton());
      this.registerNext(this.renderer.nextButton());
      this.registerThumbPrevious(this.renderer.previousThumbButton());
      this.registerThumbNext(this.renderer.nextThumbButton());
      return this.registerThumbClick(this.renderer.thumbElement());
    };
    return AntiGallery;
  })();
}).call(this);
