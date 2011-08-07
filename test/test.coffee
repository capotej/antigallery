$ ->

  IMAGES = [
    { full: '../examples/images/one.png',   thumb: '../examples/images/one_thumb.jpeg' },   #0 page 1
    { full: '../examples/images/two.png',   thumb: '../examples/images/two_thumb.jpeg' },   #1 page 1
    { full: '../examples/images/three.png', thumb: '../examples/images/three_thumb.jpeg' }, #2 page 1
    { full: '../examples/images/four.png', thumb: '../examples/images/four_thumb.jpeg' },   #3 page 2
    { full: '../examples/images/five.png', thumb: '../examples/images/five_thumb.jpeg' },   #4 page 2
    ]

  module "AntiGallery.Paginator"

  test "divide thumbs should distribute the thumbs evenly", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    equal(paginator.totalPages(), 2)

  test "should return the proper page index", ->
    paginator = new AntiGallery.Paginator(IMAGES, 3)
    equal(paginator.gotoPage(0).length, 3)
    equal(paginator.gotoPage(1).length, 2)

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


  module "AntiGallery"

  test "renders the first image and first thumbset on render()", ->
    renderer = new ExampleRenderer("div")
    renderer.paginateThreshold = 3
    mock = sinon.mock(renderer)
    mock.expects("renderThumbs").once().withArgs([IMAGES[0].thumb, IMAGES[1].thumb, IMAGES[2].thumb])
    mock.expects("renderMainImage").once().withArgs(IMAGES[0].full)
    gallery = new AntiGallery(IMAGES, renderer)
    gallery.render()
    mock.verify()

  test "renders the next image on nextImage and sets the activeThumb to the relativeIndex of that page", ->
    renderer = new ExampleRenderer("div")
    renderer.paginateThreshold = 3
    mock = sinon.mock(renderer)
    mock.expects("renderMainImage").once().withArgs(IMAGES[1].full)
    mock.expects("setActiveThumb").once().withArgs(1)
    gallery = new AntiGallery(IMAGES, renderer)
    gallery.nextImage()
    mock.verify()

  test "renders the previous image on prevImage and sets the activeThumb to the relativeIndex of that page, wrapping if neccesary", ->
    renderer = new ExampleRenderer("div")
    renderer.paginateThreshold = 3
    mock = sinon.mock(renderer)
    mock.expects("renderMainImage").once().withArgs(IMAGES[4].full) #last image
    mock.expects("setActiveThumb").once().withArgs(1) #last image of last page
    gallery = new AntiGallery(IMAGES, renderer)
    gallery.previousImage()
    mock.verify()

  test "renders the first image of the next page, sets the active thumb, and draws those thumbs on nextPage", ->
    renderer = new ExampleRenderer("div")
    renderer.paginateThreshold = 3
    mock = sinon.mock(renderer)
    mock.expects("renderThumbs").once().withArgs([IMAGES[3].thumb, IMAGES[4].thumb])
    mock.expects("renderMainImage").once().withArgs(IMAGES[3].full)
    mock.expects("setActiveThumb").once().withArgs(0)
    gallery = new AntiGallery(IMAGES, renderer)
    gallery.nextPage()
    mock.verify()

  test "renders the first image of the previous page, sets the active thumb, and draws those thumbs on prevPage", ->
    renderer = new ExampleRenderer("div")
    renderer.paginateThreshold = 3
    mock = sinon.mock(renderer)
    mock.expects("renderThumbs").once().withArgs([IMAGES[3].thumb, IMAGES[4].thumb])
    mock.expects("renderMainImage").once().withArgs(IMAGES[3].full)
    mock.expects("setActiveThumb").once().withArgs(0)
    gallery = new AntiGallery(IMAGES, renderer)
    gallery.previousPage()
    mock.verify()

