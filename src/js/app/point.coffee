class Point
  constructor: (@svg, @attrs) ->
    @attrs.r = 6 if !@attrs.r?
    @attrs.fill = '#5BCEE0' if !@attrs.fill?
    @attrs.stroke = '#0191AF' if !@attrs.stroke?

  draw: ->
    tip = @initTooltip()
    @svg.append('circle')
      .attr('cx', @attrs.x)
      .attr('cy', @attrs.y)
      .attr('r', @attrs.r)
      .attr('fill', @attrs.fill)

      .attr('stroke', @attrs.stroke)
      .attr('stroke-width', 2)

      .on('mouseover', tip.show)
      .on('mouseout', tip.hide)

  initTooltip: ->
    tip = d3.tip()
      .attr('class', 'd3-tip')
      .html (d) => @attrs.title

    @svg.call(tip)
    tip


module.exports = Point
