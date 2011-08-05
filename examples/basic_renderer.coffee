# serves as the reference implementation of a renderer
# all jquery calls go in here
class self.BasicRenderer
  constructor: (@container_div) ->

  container: ->
    $("##{@container_div}")

  # should probably pick a good default for this, but still i want *no* strings in antigallery lol
  thumbIndexName: ->
    "thumb-index"

  # takes a list of thumb urls
  renderThumbs: (thumbs) ->
    $(thumbs).each (index, object) ->
       $('#thumbs').append("<img class=\"thumb\" src=\"#{object}\" data-thumb-index=\"#{index}\"/>")

  # takes a full image url, called on boot with first image, called every time images are changed
  renderMainImage: (image) ->
    $('#main_image').empty().append("<img src=\"#{image}\"/>")

  #convinience function for doing contained selections on given gallery container
  select: (sel) ->
    $(sel, @container())

  # returns a jq selector for this galleries next button
  nextButton: ->
    @select("#next")

  # returns a jq selector for this galleries previous button
  previousButton: ->
    @select('#prev')

  thumbElement: ->
    @select('.thumb')

