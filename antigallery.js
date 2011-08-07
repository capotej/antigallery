(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  self.AntiGallery = (function() {
    function AntiGallery(images, renderer) {
      this.renderer = renderer;
      this.imageCache = {};
      this.paginator = new AntiGallery.Paginator(images, this.renderer.paginateThreshold);
      this.preloadAllThumbsAndImages(images);
    }
    AntiGallery.prototype.cacheImage = function(image) {
      return this.imageCache[image.src] = image;
    };
    AntiGallery.prototype.preloadAllThumbsAndImages = function(images) {
      var image, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = images.length; _i < _len; _i++) {
        image = images[_i];
        _results.push(this.preloadImage(image));
      }
      return _results;
    };
    AntiGallery.prototype.preloadImage = function(image) {
      var full, thumb;
      full = document.createElement('img');
      thumb = document.createElement('img');
      full.src = image.full;
      thumb.src = image.thumb;
      this.cacheImage(full);
      return this.cacheImage(thumb);
    };
    AntiGallery.prototype.stripThumb = function(image) {
      return image.thumb;
    };
    AntiGallery.prototype.stripFull = function(image) {
      return image.full;
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
        this.paginator.gotoItem(index);
        return this.renderMainImage();
      }, this));
    };
    AntiGallery.prototype.registerPageLink = function(button) {
      return button.click(__bind(function(evt) {
        var index;
        evt.preventDefault();
        index = $(evt.target).data(this.renderer.thumbSetIndexName());
        this.paginator.gotoPage(index);
        return this.renderThumbsAndMain();
      }, this));
    };
    AntiGallery.prototype.nextPage = function() {
      this.paginator.nextPage();
      return this.renderThumbsAndMain();
    };
    AntiGallery.prototype.previousPage = function() {
      this.paginator.previousPage();
      return this.renderThumbsAndMain();
    };
    AntiGallery.prototype.renderThumbPage = function() {
      return this.renderer.renderThumbs(this.stripThumbs(this.paginator.currentPage()));
    };
    AntiGallery.prototype.renderMainImage = function() {
      this.renderer.setActiveThumb(this.paginator.relativeIndex);
      return this.renderer.renderMainImage(this.stripFull(this.paginator.currentItem()));
    };
    AntiGallery.prototype.renderThumbsAndMain = function() {
      this.renderThumbPage();
      return this.renderMainImage();
    };
    AntiGallery.prototype.nextImage = function() {
      this.paginator.nextItem();
      return this.renderMainImage();
    };
    AntiGallery.prototype.previousImage = function() {
      this.paginator.previousItem();
      return this.renderMainImage();
    };
    AntiGallery.prototype.render = function() {
      this.rendererCallbacks();
      return this.registerEvents();
    };
    AntiGallery.prototype.rendererCallbacks = function() {
      this.renderer.renderNavForPages(this.paginator.pages().length);
      return this.renderThumbsAndMain();
    };
    AntiGallery.prototype.registerEvents = function() {
      this.registerPrevious(this.renderer.previousButton());
      this.registerNext(this.renderer.nextButton());
      this.registerThumbPrevious(this.renderer.previousPageButton());
      this.registerThumbNext(this.renderer.nextPageButton());
      this.registerPageLink(this.renderer.pageElement());
      return this.registerThumbClick(this.renderer.thumbElement());
    };
    return AntiGallery;
  })();
  AntiGallery.Paginator = (function() {
    /*
      Takes a collection, and lets you page item by item, or page by page
      */    function Paginator(collection, perPage) {
      this.collection = collection;
      this.pageIndex = 0;
      this.relativeIndex = 0;
      this._pages = dividePages(this.collection, perPage);
    }
    Paginator.prototype.pages = function() {
      return this._pages;
    };
    Paginator.prototype.gotoPage = function(index) {
      this.relativeIndex = 0;
      return this.pageIndex = index;
    };
    Paginator.prototype.gotoItem = function(index) {
      return this.relativeIndex = index;
    };
    Paginator.prototype.totalPages = function() {
      return this._pages.length;
    };
    Paginator.prototype.nextPage = function() {
      /*
          Forwards the cursor a whole page length forwards, setting it at the first place of that page
          */      var result;
      this.relativeIndex = 0;
      result = this.pageIndex + 1;
      if (result > this._pages.length - 1) {
        return this.pageIndex = 0;
      } else {
        return this.pageIndex = result;
      }
    };
    Paginator.prototype.previousPage = function() {
      /*
          Reverses the cursor a whole page length forwards, setting it at the first place of that page
          */      var result;
      this.relativeIndex = 0;
      result = this.pageIndex - 1;
      if (result < 0) {
        return this.pageIndex = this._pages.length - 1;
      } else {
        return this.pageIndex = result;
      }
    };
    Paginator.prototype.currentPage = function() {
      /*
          Gets current page
          */      return this._pages[this.pageIndex];
    };
    Paginator.prototype.nextItem = function() {
      /*
          Forwards the cursor one item forward, turning the page if it has to
          */      var result;
      result = this.relativeIndex + 1;
      if (result > this.currentPage().length - 1) {
        return this.nextPage();
      } else {
        return this.relativeIndex = result;
      }
    };
    Paginator.prototype.previousItem = function() {
      /*
          Reverses the cursor one item forward, turning the page if it has to
          */      var result;
      result = this.relativeIndex - 1;
      if (result < 0) {
        this.previousPage();
        return this.relativeIndex = this.currentPage().length - 1;
      } else {
        return this.relativeIndex = result;
      }
    };
    Paginator.prototype.currentItem = function() {
      /*
          Gets current item of current page
          */      return this.currentPage()[this.relativeIndex];
    };
    self.dividePages = function(collection, perPage) {
      /*
          Divides a collection into pages
          */      var arr, sub_arr;
      arr = [];
      sub_arr = [];
      $(collection).each(function(index, image) {
        index = index + 1;
        sub_arr.push(image);
        if (index % perPage === 0) {
          arr.push(sub_arr);
          return sub_arr = [];
        }
      });
      if (sub_arr.length !== 0) {
        arr.push(sub_arr);
      }
      return arr;
    };
    return Paginator;
  })();
}).call(this);
