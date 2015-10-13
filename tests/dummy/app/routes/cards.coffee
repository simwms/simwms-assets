`import Ember from 'ember'`

Ellen =
  name: "Ellen Degeneres"
  style: "Observational nostalgic"
  image: "http://i.imgur.com/yEpekDy.jpg"
Jerry =
  name: "Jerry Seinfeld"
  style: "Pure observational"
  image: "http://i.imgur.com/yEpekDy.jpg"
Louis =
  name: "Louis CK"
  style: "Lifestyle stream-of-consciousness"
  image: "http://i.imgur.com/yEpekDy.jpg"
Ray =
  name: "Ray Romano"
  style: "Family cool-dad"
  image: "http://i.imgur.com/yEpekDy.jpg"

CardsController = Ember.Route.extend
  model: ->
    Ember.A [Ellen, Jerry, Louis, Ray]

`export default CardsController`