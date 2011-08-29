(function() {
  $(function() {
    var IMAGES;
    IMAGES = [
      {
        full: '../examples/images/one.png',
        thumb: '../examples/images/one_thumb.jpeg'
      }, {
        full: '../examples/images/two.png',
        thumb: '../examples/images/two_thumb.jpeg'
      }, {
        full: '../examples/images/three.png',
        thumb: '../examples/images/three_thumb.jpeg'
      }, {
        full: '../examples/images/four.png',
        thumb: '../examples/images/four_thumb.jpeg'
      }, {
        full: '../examples/images/five.png',
        thumb: '../examples/images/five_thumb.jpeg'
      }
    ];
    module("AntiGallery.Paginator");
    test("divide thumbs should distribute the thumbs evenly", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      return equal(paginator.totalPages(), 2);
    });
    test("should return the proper page index", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      paginator.gotoPage(0);
      equal(paginator.currentPage().length, 3);
      paginator.gotoPage(1);
      return equal(paginator.currentPage().length, 2);
    });
    test("should return the next page, after next page is called", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      return paginator.nextPage();
    });
    test("should return the last page, after prev page is called on page 0", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      paginator.previousPage();
      return equal(paginator.currentPage().length, 2);
    });
    test("currentItem should always be the first of the page on next page", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      paginator.nextPage();
      return equal(paginator.currentItem(), IMAGES[3]);
    });
    test("currentItem should wrap around when pages wrap around", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      paginator.nextPage();
      paginator.nextPage();
      return equal(paginator.currentItem(), IMAGES[0]);
    });
    test("nextItem should return the next item on the page", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      paginator.nextItem();
      return equal(paginator.currentItem(), IMAGES[1]);
    });
    test("nextItem on page border should advance the page", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      paginator.nextItem();
      paginator.nextItem();
      paginator.nextItem();
      return equal(paginator.currentItem(), IMAGES[3]);
    });
    test("previousItem should return the previous item on the page, wrapping to the last item if needed", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      paginator.previousItem();
      return equal(paginator.currentItem(), IMAGES[4]);
    });
    module("AntiGallery");
    test("renders the first image/thumbset, sets the first thumb/page as active render()", function() {
      var gallery, mock, renderer;
      renderer = new ExampleRenderer("div");
      renderer.paginateThreshold = 3;
      mock = sinon.mock(renderer);
      mock.expects("renderThumbs").once().withArgs([IMAGES[0].thumb, IMAGES[1].thumb, IMAGES[2].thumb], "right");
      mock.expects("renderMainImage").once().withArgs(IMAGES[0].full);
      mock.expects("setActivePage").once().withArgs(0);
      gallery = new AntiGallery(IMAGES, renderer);
      gallery.render();
      return mock.verify();
    });
    test("renders the next image on nextImage and sets the activeThumb to the relativeIndex of that page", function() {
      var gallery, mock, renderer;
      renderer = new ExampleRenderer("div");
      renderer.paginateThreshold = 3;
      mock = sinon.mock(renderer);
      mock.expects("renderMainImage").once().withArgs(IMAGES[1].full);
      mock.expects("setActiveThumb").once().withArgs(1);
      gallery = new AntiGallery(IMAGES, renderer);
      gallery.nextImage();
      return mock.verify();
    });
    test("renders the previous image on prevImage and sets the active thumb to the relativeIndex of that page, wrapping if neccesary", function() {
      var gallery, mock, renderer;
      renderer = new ExampleRenderer("div");
      renderer.paginateThreshold = 3;
      mock = sinon.mock(renderer);
      mock.expects("renderMainImage").once().withArgs(IMAGES[4].full);
      mock.expects("setActiveThumb").once().withArgs(1);
      gallery = new AntiGallery(IMAGES, renderer);
      gallery.previousImage();
      return mock.verify();
    });
    test("renders the first image of the next page, sets the active thumb/page, and draws those thumbs on nextPage", function() {
      var gallery, mock, renderer;
      renderer = new ExampleRenderer("div");
      renderer.paginateThreshold = 3;
      mock = sinon.mock(renderer);
      mock.expects("renderThumbs").once().withArgs([IMAGES[3].thumb, IMAGES[4].thumb], "right");
      mock.expects("renderMainImage").once().withArgs(IMAGES[3].full);
      mock.expects("setActiveThumb").once().withArgs(0);
      mock.expects("setActivePage").once().withArgs(1);
      gallery = new AntiGallery(IMAGES, renderer);
      gallery.nextPage();
      return mock.verify();
    });
    test("renders the first image of the previous page, sets the active thumb/page, and draws those thumbs on prevPage", function() {
      var gallery, mock, renderer;
      renderer = new ExampleRenderer("div");
      renderer.paginateThreshold = 3;
      mock = sinon.mock(renderer);
      mock.expects("renderThumbs").once().withArgs([IMAGES[3].thumb, IMAGES[4].thumb], "left");
      mock.expects("renderMainImage").once().withArgs(IMAGES[3].full);
      mock.expects("setActiveThumb").once().withArgs(0);
      mock.expects("setActivePage").once().withArgs(1);
      gallery = new AntiGallery(IMAGES, renderer);
      gallery.previousPage();
      return mock.verify();
    });
    return test("if the gallery is less than the paginateThreshold, hide next/prev links", function() {
      var gallery, mock, renderer;
      renderer = new ExampleRenderer("div");
      renderer.paginateThreshold = 3;
      gallery = new AntiGallery([IMAGES[0], IMAGES[1]], renderer);
      mock = sinon.mock(gallery);
      mock.expects("hidePageNavigation").once();
      gallery.render();
      return mock.verify();
    });
  });
}).call(this);
