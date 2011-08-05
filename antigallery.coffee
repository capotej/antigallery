class self.AntiGallery
  constructor: (images) ->
    @images = (@tagImage(image,_i) for image in images)
    @currentIndex = 0
    @currentThumbIndex = 0

  tagImage: (image, i) ->
    image.id = i
    image

  overThreshold: ->
    @images.length > @renderer.paginateThreshold

  divideImages: ->
    arr = []
    sub_arr = []
    $(@images).each (index, image) =>
      index = index + 1
      sub_arr.push image
      if index % @renderer.paginateThreshold == 0
        arr.push sub_arr
        sub_arr = []
    arr

  stripThumb: (image) ->
    image.thumb

  stripFull: (image) ->
    image.full

  firstImage: ->
    @stripFull @images[0]

  registerNext: (button) ->
    button.click (evt) =>
      evt.preventDefault()
      @nextImage()

  registerPrevious: (button) ->
    button.click (evt) =>
      evt.preventDefault()
      @previousImage()

  registerThumbNext: (button) ->
    button.click (evt) =>
      evt.preventDefault()
      @nextImage()

  registerThumbPrevious: (button) ->
    button.click (evt) =>
      evt.preventDefault()
      @previousImage()

  registerThumbClick: (button) ->
    button.click (evt) =>
      evt.preventDefault()
      index = $(evt.target).data(@renderer.thumbIndexName())
      @setImageAndIndex(index)

  setImageAndIndex: (index) ->
    @currentIndex = index
    @renderer.renderMainImage @imageForIndex(index)

  imageForIndex: (index) ->
    @stripFull @images[index]

  nextImage: ->
    @currentIndex += 1
    if @currentIndex > @images.length - 1
      @currentIndex = 0
    @renderer.renderMainImage @imageForIndex(@currentIndex)

  previousImage: ->
    if @currentIndex == 0
      @currentIndex = @images.length - 1
    else
      @currentIndex -= 1
    @renderer.renderMainImage @imageForIndex(@currentIndex)

  extractThumbs: (set) ->
    @stripThumb image for image in set

  renderWith: (@renderer) ->
    @rendererCallbacks(@renderer)
    @registerEvents()


  rendererCallbacks: ->
    unless @overThreshold()
      @thumbs = [@images]
    else
      @thumbs = @divideImages()

    @renderer.renderMainImage @firstImage()
    @renderer.renderThumbs @thumbs[@currentThumbIndex]

  registerEvents: ->
    @registerPrevious @renderer.previousButton()
    @registerNext @renderer.nextButton()
    @registerThumbPrevious @renderer.previousThumbButton()
    @registerThumbNext @renderer.nextThumbButton()
    @registerThumbClick @renderer.thumbElement()

