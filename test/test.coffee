$ ->

  IMAGES = [
    { full: '../examples/images/one.png',   thumb: '../examples/images/one_thumb.jpeg' }, # page 1
    { full: '../examples/images/two.png',   thumb: '../examples/images/two_thumb.jpeg' }, # page 1
    { full: '../examples/images/three.png', thumb: '../examples/images/three_thumb.jpeg' }, # page 1
    { full: '../examples/images/four.png', thumb: '../examples/images/four_thumb.jpeg' }, # page 2
    { full: '../examples/images/five.png', thumb: '../examples/images/five_thumb.jpeg' }, # page 2
    ]


  module "Anti Gallery Class: Paginator"

  test "divide thumbs should distribute the thumbs evenly", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    equal(paginator.totalPages(), 2)

  test "should return the proper page index", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    equal(paginator.page(0).length, 3)
    equal(paginator.page(1).length, 2)

  test "should return the next page, after next page is called", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    paginator.nextPage()
    equal(paginator.currentPage().length, 2)

  test "should return the last page, after prev page is called on page 0", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    paginator.previousPage()
    equal(paginator.currentPage().length, 2)

  test "currentItem should always be the first of the page on next page", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    paginator.nextPage()
    equal(paginator.currentItem(), IMAGES[3])

  test "currentItem should wrap around when pages wrap around", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    paginator.nextPage()
    paginator.nextPage()
    equal(paginator.currentItem(), IMAGES[0])

  test "nextItem should return the next item on the page", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    paginator.nextItem()
    equal(paginator.currentItem(), IMAGES[1])

  test "previousItem should return the previous item on the page, wrapping to the last item if needed", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    paginator.previousItem()
    equal(paginator.currentItem(), IMAGES[4])

