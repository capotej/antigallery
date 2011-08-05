###

# Example Renderer

This defines a basic renderer for use with antigallery. All callbacks mandatory unless stated otherwise.

###
class self.ExampleRenderer
  constructor: (@container_div) ->
    ###
    (Optional) You can get creative here with your own constructor, but ours will just take a div id.
    ###

  paginateThreshold: 5
    ###
    When to paginate
    ###

  container: ->
    ###
    (Optional) Convinience function for returning a jquery object of the container div
    ###
    $("##{@container_div}")

  select: (sel) ->
    ###
    (Optional) Convinience function for returning a jquery selector scoped to a container
    ###
    $(sel, @container())


  thumbIndexName: ->
    ###
    The name of the data element that holds the thumb index (how configurable is that?!)
    ###
    "thumb-index"

  thumbSetIndexName: ->
    ###
    The name of the data element that holds the thumbset index
    ###
    "thumbset-index"

  renderThumbs: (thumbs) ->
    ###
    Takes an array of thumb urls (paged by paginatedThreshold), expects them to be drawn to the dom with a data attribute containing the id of the object
    ###
    @select('#thumbs').empty()
    $(thumbs).each (index, object) =>
      @select('#thumbs').append("<img class=\"thumb\" src=\"#{object.thumb}\" data-thumb-index=\"#{object.id}\"/>")

  renderMainImage: (image) ->
    ###
    Takes a full image url, called on page load, during prev/next, and when a thumb is clicked
    ###
    @select('#main_image').empty().append("<img src=\"#{image}\"/>")

  renderThumbPageCounter: (index) ->
    ###
    Gets called with the page number of the thumbset till there is no more, used for navigation
    ###
    @select('#thumb_nav').append("<li data-thumbset-index=\"#{index}\">#{index}</li>")

  nextButton: ->
    ###
    Needs to return a scoped selector to that gallerys next button
    ###
    @select("#next")

  previousButton: ->
    ###
    Needs to return a scoped selector to that gallerys previous button
    ###
    @select('#prev')

  nextThumbButton: ->
    ###
    Needs to return a scoped selector to that gallerys next thumbset button
    ###
    @select("#next_thumb")

  previousThumbButton: ->
    ###
    Needs to return a scoped selector to that gallerys previous thumbset button
    ###
    @select('#prev_thumb')


  thumbElement: ->
    ###
    Needs to return a scoped selector to all of the thumb img elements for the gallery
    ###
    @select('.thumb')

