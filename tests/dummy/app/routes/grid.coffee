`import Ember from 'ember'`

{run, Route, Object: O} = Ember

every = (time, cb) ->
  window.setInterval cb, time

Spinner = O.extend
  origin:
    x: 1
    y: 1
    a: 0
  incrementAngle: ->
    @incrementProperty("origin.a", 5)
    a = @get("origin.a")
    @set "origin.a", a % 360

  init: ->
    every 100, =>
      @incrementAngle()

GridRoute = Route.extend
  model: ->
    ghost: O.create
      ghostType: "point"
    door: O.create
      type: "door"
      origin:
        x: 0
        y: 0
      angle: 90
    house: O.create
      type: "house"
      origin:
        x: 3
        y: 2
      points: [
        {x: 0, y: 0}
        {x: 0, y: 3}
        {x: 4, y: 3}
        {x: 4, y: 2}
        {x: 3, y: 2}
        {x: 3, y: 1}
        {x: 2, y: 1}
        {x: 2, y: 0}
      ]
    road: O.create
      type: "road"
      origin:
        x: 2
        y: 2
      points: [
        {x: 0, y: 0}
        {x: 0, y: 7}
        {x: 3, y: 7}
        {x: 2, y: 4}
      ]
    tile: Spinner.create
      type: "entrance"
      tileImage: "assets/images/truck.png"

`export default GridRoute`