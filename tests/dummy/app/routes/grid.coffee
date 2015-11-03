`import Ember from 'ember'`

Route = Ember.Route.extend
  model: ->
    house: Ember.Object.create
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
    road: Ember.Object.create
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

`export default Route`