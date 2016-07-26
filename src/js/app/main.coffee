Point = require('./point')

class Main
  constructor: (@svg) ->

  plotData: ->
    new Point(@svg, x: 300, y: 500).draw()


window.RCPlotter = Main
