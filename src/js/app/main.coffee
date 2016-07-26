_ = require('underscore')
Point = require('./point')

class Main
  constructor: (@svg) ->
    @data = [
      {x: 800, y: 390, title: 'Acomodadores'}
      {x: 820, y: 565, title: 'Objetos perdidos y guardarropía'}
      {x: 800, y: 610, title: 'Objetos perdidos y guardarropía'}
      {x: 830, y: 520, title: 'Alojamiento'}
      {x: 830, y: 475, title: 'Prensa'}
      {x: 490, y: 220, title: 'Primeros Auxilios'}
      {x: 540, y: 100, title: 'Transporte y materiales'}
      {x: 335, y: 100, title: 'Lactancia'}
      {x: 220, y: 850, title: 'Presidencia'}
      {x: 220, y: 500, title: 'Plataforma'}
      # {x: 335, y: 750, title: ''}
      # {x: 550, y: 750, title: ''}
      # {x: 545, y: 900, title: ''}
    ]

  plotData: ->
    _.each @data, (attrs) ->
      new Point(@svg, attrs).draw()


window.RCPlotter = Main
