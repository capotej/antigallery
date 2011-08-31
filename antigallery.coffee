###
VERSION 1.1.3

MIT Licensed

Copyright Julio Capote 2011

Source at http://github.com/capotej/antigallery

Homepage at http://capotej.github.com/antigallery
###

class self.AntiGallery
  ###
  The base Anti Gallery class, listens to events, fires callbacks on provided renderer
  ###
  constructor: (images, @renderer) ->
    ###
    Takes an array of image hashes, and a renderer object. Instantiates a Paginator object, and preloads all images/thumbs.
    ###
    @imageCache = {}
    @direction = "right"
    @paginator = new AntiGallery.Paginator(images, @renderer.paginateThreshold)
    @preloadAllThumbsAndImages(images)

  cacheImage: (image) ->
    ###
    Writes an image dom object to the image cache.
    ###
    @imageCache[image.src] = image

  preloadAllThumbsAndImages: (images) ->
    ###
    Loops through all images calling preloadImage
    ###
    @preloadImage image for image in images

  preloadImage: (image) ->
    ###
    Takes an image object from the collection, and caches the full and thumb url.
    ###
    full = document.createElement('img')
    thumb = document.createElement('img')
    full.src = image.full
    thumb.src = image.thumb
    @cacheImage full
    @cacheImage thumb

  stripThumb: (image) ->
    ###
    Accessor method for getting the thumb of an image.
    ###
    image.thumb

  stripFull: (image) ->
    ###
    Accessor method for getting the full version of an image.
    ###
    image.full

  stripThumbs: (set) ->
    ###
    Takes an array of hashes, returns just the thumbs.
    ###
    @stripThumb image for image in set

  registerNext: (button) ->
    ###
    Registers the next button.
    ###
    button.click (evt) =>
      evt.preventDefault()
      @nextImage()

  registerPrevious: (button) ->
    ###
    Registers the previous button.
    ###
    button.click (evt) =>
      evt.preventDefault()
      @previousImage()

  registerThumbNext: (button) ->
    ###
    Registers the next page button.
    ###
    button.click (evt) =>
      evt.preventDefault()
      @nextPage()

  registerThumbPrevious: (button) ->
    ###
    Registers the previous page button.
    ###
    button.click (evt) =>
      evt.preventDefault()
      @previousPage()

  registerThumbClick: (button) ->
    ###
    Registers the thumb click event, bound to all the thumbnails, extracts the thumb index and goes to it.
    ###
    button.live 'click', (evt) =>
      evt.preventDefault()
      index = $(evt.target).data(@renderer.thumbIndexName())
      @paginator.gotoItem(index)
      @renderMainImage()

  registerPageLink: (button) ->
    ###
    Registers the page link event, bound to all page links, extracts the page index and goes to it.
    ###
    button.click (evt) =>
      evt.preventDefault()
      index = $(evt.target).data(@renderer.thumbSetIndexName())
      if index > @paginator.pageIndex
        @direction = "right"
      else
        @direction = "left"
      @paginator.gotoPage(index)
      @renderThumbsAndMain()

  registerMouseOverEvents: ->
    ###
    Creates or removes the keyboard events for a gallery when the mouse enters/leaves the main image area.
    ###
    @renderer.mainImage().mouseover (evt) =>
      evt.preventDefault()
      @setupKeyEvents()
    @renderer.mainImage().mouseout (evt) =>
      evt.preventDefault()
      @removeKeyEvents()

  setupKeyEvents: ->
    ###
    Binds the left and right arrow keys to nextImage and previousImage, removing any key events first.
    ###
    @removeKeyEvents()
    $(document).bind "keydown.antigallery", (evt) =>
      if evt.which == 39 #right
        evt.preventDefault()
        @nextImage()
      if evt.which == 37 #left
        evt.preventDefault()
        @previousImage()

  removeKeyEvents: ->
    ###
    Removes all keyboard events.
    ###
    $(document).unbind('keydown.antigallery')

  nextPage: ->
    ###
    Goes to the next page, renders the thumbs and the main image, sets the direction to right.
    ###
    @direction = "right"
    @paginator.nextPage()
    @renderThumbsAndMain()

  previousPage: ->
    ###
    Goes to the previous page, renders the thumbs and the main image, sets the direction to left.
    ###
    @direction = "left"
    @paginator.previousPage()
    @renderThumbsAndMain()

  renderThumbPage: ->
    ###
    Called every time we want to render a new thumbpage, sets the active page and draws the thumbs with the direction.
    ###
    @renderer.setActivePage @paginator.pageIndex
    @renderer.renderThumbs(@stripThumbs(@paginator.currentPage()), @direction)

  renderMainImage: ->
    ###
    Called every time we want to update the main image, sets the active thumb and draws the main image.
    ###
    @renderer.setActiveThumb @paginator.relativeIndex
    @renderer.renderMainImage @stripFull @paginator.currentItem()

  renderThumbsAndMain: ->
    ###
    Render the thumb pages and the main image.
    ###
    @renderThumbPage()
    @renderMainImage()

  nextImage: ->
    ###
    Goes to the next image and renders it.
    ###
    currentPage = @paginator.pageIndex
    @paginator.nextItem()
    if currentPage != @paginator.pageIndex
      @renderThumbsAndMain()
    else
      @renderMainImage()

  previousImage: ->
    ###
    Goes to the previous image and renders it.
    ###
    currentPage = @paginator.pageIndex
    @paginator.prevItem()
    if currentPage != @paginator.pageIndex
      @renderThumbsAndMain()
    else
      @renderMainImage()

  render: ->
    ###
    Main entry point, hides pagination if neededed, registers events, then renders the thumbs/main.
    ###
    @claimFirstSpot()
    @hidePageNavigation() unless @paginator.shouldPaginate()
    @renderer.renderNavForPages(@paginator.totalPages()) if @paginator.shouldPaginate()
    @registerEvents()
    @renderThumbsAndMain()

  claimFirstSpot: ->
    ###
    If the data attribute isnt there, then setup the key events for that gallery, if it is, skip, cause another already did.
    ###
    if $('body').data('first_antigallery') == undefined
      @setupKeyEvents()
      $('body').data('first_antigallery', 'done')

  hidePageNavigation: ->
    ###
    Hides the page navigation.
    ###
    @renderer.nextPageButton().hide()
    @renderer.previousPageButton().hide()

  registerEvents: ->
    ###
    Register all the events we listen for on the elements provided by the renderer.
    ###
    @registerMouseOverEvents()
    @registerPrevious @renderer.previousButton()
    @registerNext @renderer.nextButton()
    @registerThumbPrevious @renderer.previousPageButton()
    @registerThumbNext @renderer.nextPageButton()
    @registerPageLink @renderer.pageElement()
    @registerThumbClick @renderer.thumbElement()


class AntiGallery.Paginator
  ###
  Takes a collection, and lets you page item by item, or page by page, wrapping around at the ends.
  ###
  constructor: (@collection, perPage) ->
    ###
    Takes a collection and a pagination threshold, initializes the indices to 0 and divides the collection into pages.
    ###
    @pageIndex = 0
    @relativeIndex = 0
    @_pages = dividePages(@collection, perPage)

  shouldPaginate: ->
    ###
    Returns true if more than 1 page.
    ###
    @totalPages() >= 2

  gotoPage: (index) ->
    ###
    Goes directly to a page.
    ###

    @relativeIndex = 0
    @pageIndex = index

  gotoItem: (index) ->
    ###
    Goes directly to an item.
    ###
    @relativeIndex = index

  totalPages: ->
    ###
    Returns the total number of pages.
    ###
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
    if @relativeIndex == @currentPage().length - 1
      @nextPage()
    else
      @relativeIndex += 1

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









