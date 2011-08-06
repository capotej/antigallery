$ ->

  IMAGES = [
    { full: '../examples/images/one.png',   thumb: '../examples/images/one_thumb.jpeg' },
    { full: '../examples/images/two.png',   thumb: '../examples/images/two_thumb.jpeg' },
    { full: '../examples/images/three.png', thumb: '../examples/images/three_thumb.jpeg' },
    { full: '../examples/images/four.png', thumb: '../examples/images/four_thumb.jpeg' },
    ]


  module "Anti Gallery Class: Paginator"

  test "should be 0 on start", ->
    paginator = new AntiGallery.Paginator
    equal(paginator.cursor(), 0)

  test "should be 3 upon going forwards three times", ->
    paginator = new AntiGallery.Paginator
    paginator.increment(3)
    equal(paginator.cursor(), 3)

  test "should wrap and be 1 upon going forwards 5 times", ->
    paginator = new AntiGallery.Paginator
    paginator.increment(5)
    equal(paginator.cursor(), 1)
