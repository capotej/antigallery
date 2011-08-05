class self.AntiGallery
  constructor: (images) ->
    @images = (@tagImage(image,_i) for image in images)
    @currentIndex = 0
    @currentPageIndex = 0

  tagImage: (image, i) ->
    image.id = i
    image

  divideImages: ->
    arr = []
    sub_arr = []
    $(@images).each (index, image) ->
      index = index + 1
      sub_arr.push image
      if index % 5 == 0
        arr.push sub_arr
        sub_arr = []
    arr.push sub_arr unless sub_arr == []
    arr


  overThreshold: ->
    @images.length > @renderer.paginateThreshold

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
      @nextPage()

  registerThumbPrevious: (button) ->
    button.click (evt) =>
      evt.preventDefault()
      @previousPage()

  registerThumbClick: (button) ->
    button.live 'click', (evt) =>
      evt.preventDefault()
      index = $(evt.target).data(@renderer.thumbIndexName())
      @setImageAndIndex(index)

  setImageAndIndex: (index) ->
    @currentIndex = index
    @renderer.renderMainImage @imageForIndex(index)

  imageForIndex: (index) ->
    @stripFull @images[index]

  nextPage: ->
    @currentPageIndex += 1
    @renderThumbPage()

  previousPage: ->
    @currentPageIndex -= 1
    @renderThumbPage()

  renderThumbPage: ->
    offset = @currentPageIndex % @pages.length
    if offset < 0
      offset = offset * -1
    @renderer.renderThumbs @pages[offset]

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
      @pages = [@images]
    else
      @pages = @divideImages()

    @renderer.renderMainImage @firstImage()
    @renderer.renderThumbs @pages[0]

  registerEvents: ->
    @registerPrevious @renderer.previousButton()
    @registerNext @renderer.nextButton()
    @registerThumbPrevious @renderer.previousPageButton()
    @registerThumbNext @renderer.nextPageButton()
    @registerThumbClick @renderer.thumbElement()

