# contains 0% jquery calls, could concievably even be used serverside
class self.AntiGallery
  constructor: (@images) ->

  stripThumb: (image) ->
    image.thumb

  thumbs: ->
    @stripThumb image for image in @images

  renderWith: (@renderer) ->
    @renderer.renderThumbs @thumbs()

