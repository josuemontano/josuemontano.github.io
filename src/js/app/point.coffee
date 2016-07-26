class Point
  constructor: (@svg, @attrs) ->
    @attrs.r = 5 if !@attrs.r?
    @attrs.fill = '#5BCEE0' if !@attrs.fill?
    @attrs.stroke = '#0191AF' if !@attrs.stroke?

  draw: ->
    tooltip = @drawTooltip()

    @svg.append('circle')
      .attr('cx', @attrs.x)
      .attr('cy', @attrs.y)
      .attr('r', @attrs.r)
      .attr('fill', @attrs.fill)

      .attr('stroke', @attrs.stroke)
      .attr('stroke-width', 2)

      .on('mouseover', (d) ->
        tooltip.transition()
              .duration(200)
              .style('opacity', 1)
      ).on('mouseout', (d) ->
        tooltip.transition()
              .duration(500)
              .style('opacity', 0)
      )

  drawTooltip: ->
    tooltip = d3.select('body').append('div')
    tooltip.html @attrs.title
    tooltip.attr 'class', 'tooltip'
    tooltip


module.exports = Point
