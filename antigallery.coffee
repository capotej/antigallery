class self.AntiGallery
  constructor: (images, @renderer) ->
    @imageCache = {}
    @paginator = new AntiGallery.Paginator(images, @renderer.paginateThreshold)
    @preloadImages(@stripThumbs(@paginator.currentPage()))

  cacheImage: (image) ->
    @imageCache[image.src] = image

  preloadImages: (images) ->
    @preloadImage image for image in images

  preloadImage: (image) ->
    img = document.createElement('img');
    img.src = image
    @cacheImage img

  preloadNearbyThumbSets: ->
    #stubbed

  preloadNearbyImages: ->
    #stubbed

  stripThumb: (image) ->
    image.thumb

  stripId: (image) ->
    image.id

  stripFull: (image) ->
    image.full

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
      @paginator.gotoItem(index)
      @renderer.setActiveThumb @paginator.relativeIndex
      @renderer.renderMainImage @stripFull @paginator.currentItem()

  registerPageCounter: (button) ->
    button.click (evt) =>
      evt.preventDefault()
      index = $(evt.target).data(@renderer.thumbSetIndexName())
      @paginator.gotoPage(index)
      @renderThumbPage()
      @renderer.setActiveThumb @paginator.relativeIndex
      @renderer.renderMainImage @stripFull @paginator.currentItem()

  nextPage: ->
    @paginator.nextPage()
    @renderThumbPage()
    @renderer.setActiveThumb @paginator.relativeIndex
    @renderer.renderMainImage @stripFull @paginator.currentItem()

  previousPage: ->
    @paginator.previousPage()
    @renderThumbPage()
    @renderer.setActiveThumb @paginator.relativeIndex
    @renderer.renderMainImage @stripFull @paginator.currentItem()

  renderThumbPage: ->
    @preloadNearbyThumbSets()
    @preloadNearbyImages()
    @renderer.renderThumbs @stripThumbs @paginator.currentPage()

  nextImage: ->
    @paginator.nextItem()
    @renderer.setActiveThumb @paginator.relativeIndex
    @renderer.renderMainImage @stripFull @paginator.currentItem()

  previousImage: ->
    @paginator.previousItem()
    @renderer.setActiveThumb @paginator.relativeIndex
    @renderer.renderMainImage @stripFull @paginator.currentItem()

  stripThumbs: (set) ->
    @stripThumb image for image in set

  render: ->
    @rendererCallbacks()
    @registerEvents()

  rendererCallbacks: ->
    @renderer.renderNavForPages(@paginator.pages().length)
    @renderer.renderThumbs @stripThumbs @paginator.currentPage()
    @renderer.renderMainImage @stripFull @paginator.currentItem()

  registerEvents: ->
    @registerPrevious @renderer.previousButton()
    @registerNext @renderer.nextButton()
    @registerThumbPrevious @renderer.previousPageButton()
    @registerThumbNext @renderer.nextPageButton()
    @registerPageCounter @renderer.pageElement()
    @registerThumbClick @renderer.thumbElement()


class AntiGallery.Paginator
  ###
  Takes a collection, and lets you page item by item, or page by page
  ###

  constructor: (@collection, perPage) ->
    @pageIndex = 0
    @relativeIndex = 0
    @_pages = dividePages(@collection, perPage)

  pages: ->
    @_pages

  gotoPage: (index) ->
    @relativeIndex = 0
    @pageIndex = index

  gotoItem: (index) ->
    @relativeIndex = index

  totalPages: ->
    @_pages.length

  nextPage: ->
    ###
    Forwards the cursor a whole page length forwards, setting it at the first place of that page
    ###
    @relativeIndex = 0
    result = @pageIndex + 1
    if result > @_pages.length - 1
      @pageIndex = 0
    else
      @pageIndex = result

  previousPage: ->
    ###
    Reverses the cursor a whole page length forwards, setting it at the first place of that page
    ###
    @relativeIndex = 0
    result = @pageIndex - 1
    if result < 0
      @pageIndex = @_pages.length - 1
    else
      @pageIndex = result

  currentPage: ->
    ###
    Gets current page
    ###
    @_pages[@pageIndex]

  nextItem: ->
    ###
    Forwards the cursor one item forward, turning the page if it has to
    ###
    result = @relativeIndex + 1
    if result > @currentPage().length - 1
      @nextPage()
    else
      @relativeIndex = result

  previousItem: ->
    ###
    Reverses the cursor one item forward, turning the page if it has to
    ###
    result = @relativeIndex - 1
    if result < 0
      @previousPage()
      @relativeIndex = @currentPage().length - 1
    else
      @relativeIndex = result

  currentItem: ->
    ###
    Gets current item of current page
    ###
    @currentPage()[@relativeIndex]

  self.dividePages = (collection, perPage) ->
    ###
    Divides a collection into pages
    ###
    arr = []
    sub_arr = []
    $(collection).each (index, image) ->
      index = index + 1
      sub_arr.push image
      if index % perPage == 0
        arr.push sub_arr
        sub_arr = []
    arr.push sub_arr unless sub_arr == []
    arr







