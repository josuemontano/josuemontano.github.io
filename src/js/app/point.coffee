class Point
  constructor: (@svg, @attrs) ->
    @attrs.r = 6 if !@attrs.r?
    @attrs.fill = '#5BCEE0' if !@attrs.fill?
    @attrs.stroke = '#0191AF' if !@attrs.stroke?

  draw: ->
    tooltip = @createTooltip()
    @svg.append('circle')
      .attr('cx', @attrs.x)
      .attr('cy', @attrs.y)
      .attr('r', @attrs.r)
      .attr('fill', @attrs.fill)

      .attr('stroke', @attrs.stroke)
      .attr('stroke-width', 2)

      .on('mouseover', (d) -> tooltip.transition().duration(200).style('opacity', .9))
      .on('mouseout', (d) -> tooltip.transition().duration(500).style('opacity', 0))

  createTooltip: ->
    tooltip = d3.select('body').append('div')
      .attr('class', 'tooltip')
      .style('opacity', 0)
      .text(@attrs.title)
    tooltip

  createLabel: ->
    @svg.append('text')
      .attr('x', @attrs.x)
      .attr('y', @attrs.y - 14)
      .attr('text-anchor', 'middle')
      .classed('label', true)
      .text (d) => @attrs.title


module.exports = Point
