$ ->

  IMAGES = [
    { full: '../examples/images/one.png',   thumb: '../examples/images/one_thumb.jpeg' },
    { full: '../examples/images/two.png',   thumb: '../examples/images/two_thumb.jpeg' },
    { full: '../examples/images/three.png', thumb: '../examples/images/three_thumb.jpeg' },
    { full: '../examples/images/four.png', thumb: '../examples/images/four_thumb.jpeg' },
    { full: '../examples/images/five.png', thumb: '../examples/images/five_thumb.jpeg' },
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
    equal(paginator.nextPage().length, 2)

  test "should return the last page, after prev page is called on page 0", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    equal(paginator.prevPage().length, 2)

  test "cursor should follow along page changes", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    paginator.nextPage()
    equal(paginator.cursor, 3) # 4 - 1

  test "cursor should follow along page changes and wrap", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    paginator.nextPage()
    paginator.nextPage()
    equal(paginator.cursor, 0)

