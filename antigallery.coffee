class self.AntiGallery
  constructor: (images, @renderer) ->
    @imageCache = {}
    @paginator = new AntiGallery.Paginator(images, @renderer.paginateThreshold)
    #@preloadImages(@stripThumbs(@images[0...5]))

  tagImage: (image, i) ->
    image.id = i
    image

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
      @setImageAndIndex(index)

  registerPageCounter: (button) ->
    button.click (evt) =>
      evt.preventDefault()
      index = $(evt.target).data(@renderer.thumbSetIndexName())
      @renderer.renderThumbs @pages[index]

  setImageAndIndex: (index) ->
    @currentIndex = index
    @renderer.setActiveThumb index
    @renderer.renderMainImage @imageForIndex(index)

  imageForIndex: (index) ->
    @stripFull @images[@mod(index, @images.length)]

  thumbForIndex: (index) ->
    @stripThumb @images[@mod(index, @images.length)]

  idForIndex: (index) ->
    @stripId @images[@mod(index, @images.length)]

  relativeIndex: ->
    @mod(@images.length, @currentIndex)# - @renderer.paginateThreshold

  nextPage: ->
    @currentPageIndex += 1
    @currentIndex += @renderer.paginateThreshold
    @renderThumbPage()
    @renderer.renderMainImage @imageForIndex @currentIndex
    @renderer.setActiveThumb @idForIndex @currentIndex

  previousPage: ->
    @currentPageIndex -= 1
    @currentIndex -= @renderer.paginateThreshold
    @renderThumbPage()
    @renderer.renderMainImage @imageForIndex @currentIndex
    @renderer.setActiveThumb @idForIndex @currentIndex

  renderThumbPage: ->
    @preloadNearbyThumbSets()
    @preloadNearbyImages()
    @renderer.renderThumbs @pages[@mod(@currentPageIndex, @pages.length)]

  nextImage: ->
    @currentIndex += 1
    @renderer.setActiveThumb @idForIndex @currentIndex
    @renderer.renderMainImage @imageForIndex @currentIndex

  previousImage: ->
    @currentIndex -= 1
    @renderer.setActiveThumb @idForIndex @currentIndex
    @renderer.renderMainImage @imageForIndex @currentIndex

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

  page: (index) ->
    @_pages[index]

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







