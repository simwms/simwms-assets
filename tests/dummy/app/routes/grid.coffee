`import Ember from 'ember'`

{Route, Object: O} = Ember

GridRoute = Route.extend
  model: ->
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
    tile: O.create
      type: "entrance"
      origin:
        x: 1
        y: 1

`export default GridRoute`