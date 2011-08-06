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
    module("Anti Gallery Class: Paginator");
    test("divide thumbs should distribute the thumbs evenly", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      return equal(paginator.totalPages(), 2);
    });
    test("should return the proper page index", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      equal(paginator.page(0).length, 3);
      return equal(paginator.page(1).length, 2);
    });
    test("should return the next page, after next page is called", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      return equal(paginator.nextPage().length, 2);
    });
    test("should return the last page, after prev page is called on page 0", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      return equal(paginator.prevPage().length, 2);
    });
    test("cursor should follow along page changes", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      paginator.nextPage();
      return equal(paginator.cursor, 3);
    });
    return test("cursor should follow along page changes and wrap", function() {
      var paginator;
      paginator = new AntiGallery.Paginator(IMAGES, 3);
      paginator.nextPage();
      paginator.nextPage();
      return equal(paginator.cursor, 0);
    });
  });
}).call(this);
