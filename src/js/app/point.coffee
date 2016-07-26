class Point
  constructor: (@svg, @attrs) ->
    @attrs.r = 5 if !@attrs.r?

  draw: ->
    @svg.append('circle')
        .attr('cx', @attrs.x)
        .attr('cy', @attrs.y)
        .attr('r', @attrs.r)


module.exports = Point
