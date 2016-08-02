_ = require('underscore')
Point = require('./point')

class Main
  constructor: (@svg) ->
    @data = [
      {x: 1050, y: 490, title: 'Acomodadores'}
      {x: 1080, y: 580, title: 'Prensa'}
      {x: 1080, y: 625, title: 'Alojamiento'}
      {x: 1070, y: 670, title: 'Objetos perdidos y guardarropía'}
      {x: 1050, y: 715, title: 'Objetos perdidos y guardarropía'}
      {x: 1200, y: 460, title: 'Información'}
      {x: 1200, y: 750, title: 'Estacionamiento 1'}
      {x: 820, y: 200, title: 'Transporte y materiales'}
      {x: 610, y: 190, title: 'Lactancia'}
      {x: 740, y: 315, title: 'Primeros Auxilios'}
      {x: 660, y: 340, title: 'Bautismo'}
      {x: 410, y: 960, title: 'Presidencia'}
      {x: 420, y: 600, title: 'Plataforma'}
    ]

  plotData: ->
    _.each @data, (attrs) ->
      new Point(@svg, attrs).draw()


window.RCPlotter = Main
