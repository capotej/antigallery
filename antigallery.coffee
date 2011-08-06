window.mod = (a, b) =>
  r = a % b
  if r >= 0
    r
  else
    window.mod a + b, b

class self.AntiGallery
  constructor: (images) ->
    @currentIndex = 0
    @currentPageIndex = 0
    @imageCache = {}
    @images = (@tagImage(image,_i) for image in images)
    @preloadImages(@stripThumbs(@images[0...5]))

  tagImage: (image, i) ->
    image.id = i
    image


  cacheImage: (image) ->
    @imageCache[image.src]

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

  overThreshold: ->
    @images.length > @renderer.paginateThreshold

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

  renderWith: (@renderer) ->
    @rendererCallbacks()
    @registerEvents()

  rendererCallbacks: ->
    unless @overThreshold()
      @pages = [@images]
    else
      @pages = @divideImages()
    @renderer.renderNavForPages(@pages.length)
    @renderer.renderThumbs @pages[0]
    @setImageAndIndex(0)

  registerEvents: ->
    @registerPrevious @renderer.previousButton()
    @registerNext @renderer.nextButton()
    @registerThumbPrevious @renderer.previousPageButton()
    @registerThumbNext @renderer.nextPageButton()
    @registerPageCounter @renderer.pageElement()
    @registerThumbClick @renderer.thumbElement()


class AntiGallery.Paginator
  constructor: (@collection, perPage) ->
    @currentIndex = 0
    @_pages = @dividePages(@collection, perPage)

  cursor: ->
    @currentIndex

  increment: (num = 1) ->
    @currentIndex += num

  pages: ->
    @_pages

  page: (index) ->
    @_pages[index]

  totalPages: ->
    @_pages.length

  dividePages: (collection, perPage) ->
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







