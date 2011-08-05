# contains 0% jquery calls, could concievably even be used serverside
class self.AntiGallery
  constructor: (@images) ->

  stripThumb: (image) ->
    image.thumb

  stripFull: (image) ->
    image.full

  firstImage: ->
    @stripFull @images[0]

  registerNext: (button) ->
    button.click (evt) ->
      evt.preventDefault()
      @nextImage()

  registerPrevious: (button) ->
    button.click (evt) ->
      evt.preventDefault()
      @previousImage()

  thumbs: ->
    @stripThumb image for image in @images

  renderWith: (@renderer) ->
    @registerPrevious @renderer.previousButton()
    @registerNext @renderer.nextButton()
    @renderer.nextButton
    @renderer.renderMainImage @firstImage()
    @renderer.renderThumbs @thumbs()


