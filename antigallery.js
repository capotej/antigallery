(function() {
  /*
  VERSION 1.1.3
  
  MIT Licensed
  
  Copyright Julio Capote 2011
  
  Source at http://github.com/capotej/antigallery
  
  Homepage at http://capotej.github.com/antigallery
  */  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  self.AntiGallery = (function() {
    /*
      The base Anti Gallery class, listens to events, fires callbacks on provided renderer
      */    function AntiGallery(images, renderer) {
      this.renderer = renderer;
      /*
          Takes an array of image hashes, and a renderer object. Instantiates a Paginator object, and preloads all images/thumbs.
          */
      this.imageCache = {};
      this.direction = "right";
      this.paginator = new AntiGallery.Paginator(images, this.renderer.paginateThreshold);
      this.preloadAllThumbsAndImages(images);
    }
    AntiGallery.prototype.cacheImage = function(image) {
      /*
          Writes an image dom object to the image cache.
          */      return this.imageCache[image.src] = image;
    };
    AntiGallery.prototype.preloadAllThumbsAndImages = function(images) {
      /*
          Loops through all images calling preloadImage
          */      var image, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = images.length; _i < _len; _i++) {
        image = images[_i];
        _results.push(this.preloadImage(image));
      }
      return _results;
    };
    AntiGallery.prototype.preloadImage = function(image) {
      /*
          Takes an image object from the collection, and caches the full and thumb url.
          */      var full, thumb;
      full = document.createElement('img');
      thumb = document.createElement('img');
      full.src = image.full;
      thumb.src = image.thumb;
      this.cacheImage(full);
      return this.cacheImage(thumb);
    };
    AntiGallery.prototype.stripThumb = function(image) {
      /*
          Accessor method for getting the thumb of an image.
          */      return image.thumb;
    };
    AntiGallery.prototype.stripFull = function(image) {
      /*
          Accessor method for getting the full version of an image.
          */      return image.full;
    };
    AntiGallery.prototype.stripThumbs = function(set) {
      /*
          Takes an array of hashes, returns just the thumbs.
          */      var image, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = set.length; _i < _len; _i++) {
        image = set[_i];
        _results.push(this.stripThumb(image));
      }
      return _results;
    };
    AntiGallery.prototype.registerNext = function(button) {
      /*
          Registers the next button.
          */      return button.click(__bind(function(evt) {
        evt.preventDefault();
        return this.nextImage();
      }, this));
    };
    AntiGallery.prototype.registerPrevious = function(button) {
      /*
          Registers the previous button.
          */      return button.click(__bind(function(evt) {
        evt.preventDefault();
        return this.previousImage();
      }, this));
    };
    AntiGallery.prototype.registerThumbNext = function(button) {
      /*
          Registers the next page button.
          */      return button.click(__bind(function(evt) {
        evt.preventDefault();
        return this.nextPage();
      }, this));
    };
    AntiGallery.prototype.registerThumbPrevious = function(button) {
      /*
          Registers the previous page button.
          */      return button.click(__bind(function(evt) {
        evt.preventDefault();
        return this.previousPage();
      }, this));
    };
    AntiGallery.prototype.registerThumbClick = function(button) {
      /*
          Registers the thumb click event, bound to all the thumbnails, extracts the thumb index and goes to it.
          */      return button.live('click', __bind(function(evt) {
        var index;
        evt.preventDefault();
        index = $(evt.target).data(this.renderer.thumbIndexName());
        this.paginator.gotoItem(index);
        return this.renderMainImage();
      }, this));
    };
    AntiGallery.prototype.registerPageLink = function(button) {
      /*
          Registers the page link event, bound to all page links, extracts the page index and goes to it.
          */      return button.click(__bind(function(evt) {
        var index;
        evt.preventDefault();
        index = $(evt.target).data(this.renderer.thumbSetIndexName());
        if (index > this.paginator.pageIndex) {
          this.direction = "right";
        } else {
          this.direction = "left";
        }
        this.paginator.gotoPage(index);
        return this.renderThumbsAndMain();
      }, this));
    };
    AntiGallery.prototype.registerMouseOverEvents = function() {
      /*
          Creates or removes the keyboard events for a gallery when the mouse enters/leaves the main image area.
          */      this.renderer.mainImage().mouseover(__bind(function(evt) {
        evt.preventDefault();
        return this.setupKeyEvents();
      }, this));
      return this.renderer.mainImage().mouseout(__bind(function(evt) {
        evt.preventDefault();
        return this.removeKeyEvents();
      }, this));
    };
    AntiGallery.prototype.setupKeyEvents = function() {
      /*
          Binds the left and right arrow keys to nextImage and previousImage, removing any key events first.
          */      this.removeKeyEvents();
      return $(document).bind("keydown.antigallery", __bind(function(evt) {
        if (evt.which === 39) {
          evt.preventDefault();
          this.nextImage();
        }
        if (evt.which === 37) {
          evt.preventDefault();
          return this.previousImage();
        }
      }, this));
    };
    AntiGallery.prototype.removeKeyEvents = function() {
      /*
          Removes all keyboard events.
          */      return $(document).unbind('keydown.antigallery');
    };
    AntiGallery.prototype.nextPage = function() {
      /*
          Goes to the next page, renders the thumbs and the main image, sets the direction to right.
          */      this.direction = "right";
      this.paginator.nextPage();
      return this.renderThumbsAndMain();
    };
    AntiGallery.prototype.previousPage = function() {
      /*
          Goes to the previous page, renders the thumbs and the main image, sets the direction to left.
          */      this.direction = "left";
      this.paginator.previousPage();
      return this.renderThumbsAndMain();
    };
    AntiGallery.prototype.renderThumbPage = function() {
      /*
          Called every time we want to render a new thumbpage, sets the active page and draws the thumbs with the direction.
          */      this.renderer.setActivePage(this.paginator.pageIndex);
      return this.renderer.renderThumbs(this.stripThumbs(this.paginator.currentPage()), this.direction);
    };
    AntiGallery.prototype.renderMainImage = function() {
      /*
          Called every time we want to update the main image, sets the active thumb and draws the main image.
          */      this.renderer.setActiveThumb(this.paginator.relativeIndex);
      return this.renderer.renderMainImage(this.stripFull(this.paginator.currentItem()));
    };
    AntiGallery.prototype.renderThumbsAndMain = function() {
      /*
          Render the thumb pages and the main image.
          */      this.renderThumbPage();
      return this.renderMainImage();
    };
    AntiGallery.prototype.nextImage = function() {
      /*
          Goes to the next image and renders it.
          */      var currentPage;
      currentPage = this.paginator.pageIndex;
      this.paginator.nextItem();
      if (currentPage !== this.paginator.pageIndex) {
        return this.renderThumbsAndMain();
      } else {
        return this.renderMainImage();
      }
    };
    AntiGallery.prototype.previousImage = function() {
      /*
          Goes to the previous image and renders it.
          */      var currentPage;
      currentPage = this.paginator.pageIndex;
      this.paginator.prevItem();
      if (currentPage !== this.paginator.pageIndex) {
        return this.renderThumbsAndMain();
      } else {
        return this.renderMainImage();
      }
    };
    AntiGallery.prototype.render = function() {
      /*
          Main entry point, hides pagination if neededed, registers events, then renders the thumbs/main.
          */      this.claimFirstSpot();
      if (!this.paginator.shouldPaginate()) {
        this.hidePageNavigation();
      }
      if (this.paginator.shouldPaginate()) {
        this.renderer.renderNavForPages(this.paginator.totalPages());
      }
      this.registerEvents();
      return this.renderThumbsAndMain();
    };
    AntiGallery.prototype.claimFirstSpot = function() {
      /*
          If the data attribute isnt there, then setup the key events for that gallery, if it is, skip, cause another already did.
          */      if ($('body').data('first_antigallery') === void 0) {
        this.setupKeyEvents();
        return $('body').data('first_antigallery', 'done');
      }
    };
    AntiGallery.prototype.hidePageNavigation = function() {
      /*
          Hides the page navigation.
          */      this.renderer.nextPageButton().hide();
      return this.renderer.previousPageButton().hide();
    };
    AntiGallery.prototype.registerEvents = function() {
      /*
          Register all the events we listen for on the elements provided by the renderer.
          */      this.registerMouseOverEvents();
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
      Takes a collection, and lets you page item by item, or page by page, wrapping around at the ends.
      */    function Paginator(collection, perPage) {
      this.collection = collection;
      /*
          Takes a collection and a pagination threshold, initializes the indices to 0 and divides the collection into pages.
          */
      this.pageIndex = 0;
      this.relativeIndex = 0;
      this._pages = dividePages(this.collection, perPage);
    }
    Paginator.prototype.shouldPaginate = function() {
      /*
          Returns true if more than 1 page.
          */      return this.totalPages() >= 2;
    };
    Paginator.prototype.gotoPage = function(index) {
      /*
          Goes directly to a page.
          */      this.relativeIndex = 0;
      return this.pageIndex = index;
    };
    Paginator.prototype.gotoItem = function(index) {
      /*
          Goes directly to an item.
          */      return this.relativeIndex = index;
    };
    Paginator.prototype.totalPages = function() {
      /*
          Returns the total number of pages.
          */      return this._pages.length;
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
          */      if (this.relativeIndex === this.currentPage().length - 1) {
        return this.nextPage();
      } else {
        return this.relativeIndex += 1;
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
