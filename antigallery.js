(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  self.AntiGallery = (function() {
    function AntiGallery(images) {
      var image;
      this.currentIndex = 0;
      this.currentPageIndex = 0;
      this.imageCache = {};
      this.images = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = images.length; _i < _len; _i++) {
          image = images[_i];
          _results.push(this.tagImage(image, _i));
        }
        return _results;
      }).call(this);
      this.preloadImages(this.stripThumbs(this.images.slice(0, 5)));
    }
    AntiGallery.prototype.tagImage = function(image, i) {
      image.id = i;
      return image;
    };
    AntiGallery.prototype.divideImages = function() {
      var arr, sub_arr;
      arr = [];
      sub_arr = [];
      $(this.images).each(function(index, image) {
        index = index + 1;
        sub_arr.push(image);
        if (index % 5 === 0) {
          arr.push(sub_arr);
          return sub_arr = [];
        }
      });
      if (sub_arr !== []) {
        arr.push(sub_arr);
      }
      return arr;
    };
    AntiGallery.prototype.cacheImage = function(image) {
      return this.imageCache[image.src];
    };
    AntiGallery.prototype.preloadImages = function(images) {
      var image, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = images.length; _i < _len; _i++) {
        image = images[_i];
        _results.push(this.preloadImage(image));
      }
      return _results;
    };
    AntiGallery.prototype.preloadImage = function(image) {
      var img;
      img = document.createElement('img');
      img.src = image;
      return this.cacheImage(img);
    };
    AntiGallery.prototype.overThreshold = function() {
      return this.images.length > this.renderer.paginateThreshold;
    };
    AntiGallery.prototype.stripThumb = function(image) {
      return image.thumb;
    };
    AntiGallery.prototype.stripFull = function(image) {
      return image.full;
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
        return this.nextPage();
      }, this));
    };
    AntiGallery.prototype.registerThumbPrevious = function(button) {
      return button.click(__bind(function(evt) {
        evt.preventDefault();
        return this.previousPage();
      }, this));
    };
    AntiGallery.prototype.registerThumbClick = function(button) {
      return button.live('click', __bind(function(evt) {
        var index;
        evt.preventDefault();
        index = $(evt.target).data(this.renderer.thumbIndexName());
        return this.setImageAndIndex(index);
      }, this));
    };
    AntiGallery.prototype.registerPageCounter = function(button) {
      return button.click(__bind(function(evt) {
        var index;
        evt.preventDefault();
        index = $(evt.target).data(this.renderer.thumbSetIndexName());
        return this.renderer.renderThumbs(this.pages[index]);
      }, this));
    };
    AntiGallery.prototype.setImageAndIndex = function(index) {
      this.currentIndex = index;
      this.renderer.setActiveThumb(index);
      return this.renderer.renderMainImage(this.imageForIndex(index));
    };
    AntiGallery.prototype.imageForIndex = function(index) {
      return this.stripFull(this.images[index]);
    };
    AntiGallery.prototype.thumbForIndex = function(index) {
      return this.stripThumb(this.images[index]);
    };
    AntiGallery.prototype.nextPage = function() {
      this.currentPageIndex += 1;
      this.renderThumbPage();
      return this.renderer.setActiveThumb(this.currentIndex);
    };
    AntiGallery.prototype.previousPage = function() {
      this.currentPageIndex -= 1;
      this.renderThumbPage();
      return this.renderer.setActiveThumb(this.currentIndex);
    };
    AntiGallery.prototype.renderThumbPage = function() {
      var offset;
      offset = this.currentPageIndex % this.pages.length;
      if (offset < 0) {
        offset *= -1;
      }
      this.preloadNearbyThumbSets();
      this.preloadNearbyImages();
      return this.renderer.renderThumbs(this.pages[offset]);
    };
    AntiGallery.prototype.preloadNearbyThumbSets = function() {};
    AntiGallery.prototype.preloadNearbyImages = function() {};
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
    AntiGallery.prototype.stripThumbs = function(set) {
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
        this.pages = [this.images];
      } else {
        this.pages = this.divideImages();
      }
      this.renderer.renderNavForPages(this.pages.length);
      this.renderer.renderThumbs(this.pages[0]);
      return this.setImageAndIndex(0);
    };
    AntiGallery.prototype.registerEvents = function() {
      this.registerPrevious(this.renderer.previousButton());
      this.registerNext(this.renderer.nextButton());
      this.registerThumbPrevious(this.renderer.previousPageButton());
      this.registerThumbNext(this.renderer.nextPageButton());
      this.registerPageCounter(this.renderer.pageElement());
      return this.registerThumbClick(this.renderer.thumbElement());
    };
    return AntiGallery;
  })();
}).call(this);
