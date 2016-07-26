_ = require('underscore')
Point = require('./point')

class Main
  constructor: (@svg) ->
    @data = [
      {x: 800, y: 390, title: ''}
      {x: 820, y: 565, title: ''}
      {x: 800, y: 610, title: ''}
      {x: 490, y: 220, title: ''}
      {x: 540, y: 100, title: ''}
      {x: 335, y: 100, title: ''}
      {x: 335, y: 750, title: ''}
      {x: 550, y: 750, title: ''}
      {x: 545, y: 900, title: ''}
    ]

  plotData: ->
    _.each @data, (attrs) ->
      new Point(@svg, attrs).draw()


window.RCPlotter = Main
