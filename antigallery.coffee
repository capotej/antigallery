class self.AntiGallery
  constructor: (images, @renderer) ->
    @imageCache = {}
    @paginator = new AntiGallery.Paginator(images, @renderer.paginateThreshold)
    @preloadAllThumbsAndImages(images)

  cacheImage: (image) ->
    @imageCache[image.src] = image

  preloadAllThumbsAndImages: (images) ->
    @preloadImage image for image in images

  preloadImage: (image) ->
    full = document.createElement('img');
    thumb = document.createElement('img');
    full.src = image.full
    thumb.src = image.thumb
    @cacheImage full
    @cacheImage thumb

  stripThumb: (image) ->
    image.thumb

  stripFull: (image) ->
    image.full

  stripThumbs: (set) ->
    @stripThumb image for image in set

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
      @renderMainImage()

  registerPageLink: (button) ->
    button.click (evt) =>
      evt.preventDefault()
      index = $(evt.target).data(@renderer.thumbSetIndexName())
      @paginator.gotoPage(index)
      @renderThumbsAndMain()

  nextPage: ->
    @paginator.nextPage()
    @renderThumbsAndMain()

  previousPage: ->
    @paginator.previousPage()
    @renderThumbsAndMain()

  renderThumbPage: ->
    @renderer.setActivePage @paginator.pageIndex
    @renderer.renderThumbs @stripThumbs @paginator.currentPage()

  renderMainImage: ->
    @renderer.setActiveThumb @paginator.relativeIndex
    @renderer.renderMainImage @stripFull @paginator.currentItem()

  renderThumbsAndMain: ->
    @renderThumbPage()
    @renderMainImage()

  nextImage: ->
    @paginator.nextItem()
    @renderMainImage()

  previousImage: ->
    @paginator.previousItem()
    @renderMainImage()

  render: ->
    @hidePageNavigation() unless @paginator.shouldPaginate()
    @rendererCallbacks()
    @registerEvents()

  hidePageNavigation: ->
    @renderer.nextPageButton().hide()
    @renderer.previousPageButton().hide()

  rendererCallbacks: ->
    @renderer.renderNavForPages(@paginator.pages().length)
    @renderThumbsAndMain()

  registerEvents: ->
    @registerPrevious @renderer.previousButton()
    @registerNext @renderer.nextButton()
    @registerThumbPrevious @renderer.previousPageButton()
    @registerThumbNext @renderer.nextPageButton()
    @registerPageLink @renderer.pageElement()
    @registerThumbClick @renderer.thumbElement()


class AntiGallery.Paginator
  ###
  Takes a collection, and lets you page item by item, or page by page
  ###

  constructor: (@collection, perPage) ->
    @pageIndex = 0
    @relativeIndex = 0
    @_pages = dividePages(@collection, perPage)

  shouldPaginate: ->
    @_pages.length >= 2

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
    arr.push sub_arr unless sub_arr.length == 0
    arr







