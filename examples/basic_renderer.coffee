# serves as the reference implementation of a renderer
# all jquery calls go in here
class self.BasicRenderer
  constructor: (@container_div) ->

  # takes a list of thumb urls
  renderThumbs: (thumbs) ->
    $(thumbs).each (index, object) ->
       $('#thumbs').append("<img src=\"#{object}\"/>")


