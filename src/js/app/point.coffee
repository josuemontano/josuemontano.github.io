class Point
  constructor: (@svg, @attrs) ->
    @attrs.r = 5 if !@attrs.r?
    @attrs.fill = '#5BCEE0' if !@attrs.fill?
    @attrs.stroke = '#0191AF' if !@attrs.stroke?

  draw: ->
    @svg.append('circle')
        .attr('cx', @attrs.x)
        .attr('cy', @attrs.y)
        .attr('r', @attrs.r)
        .attr('fill', @attrs.fill)

        .attr('stroke', @attrs.stroke)
        .attr('stroke-width', 2)


module.exports = Point
