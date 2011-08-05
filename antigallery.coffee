class self.AntiGallery
  constructor: (@images) ->
    @currentIndex = 0
    @currentThumbIndex = 0

  overThreshold: ->
    @images.length > @renderer.paginateThreshold

  divideImages: ->
    arr = []
    sub_arr = []
    $(@images).each (index, image) ->
      index = index + 1
      sub_arr.push image
      if index % 5 == 0
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

    console.log @thumbs[0]
    @renderer.renderMainImage @firstImage()
    @renderer.renderThumbs @extractThumbs(@thumbs[0])

  registerEvents: ->
    @registerPrevious @renderer.previousButton()
    @registerNext @renderer.nextButton()
    @registerThumbClick @renderer.thumbElement()

