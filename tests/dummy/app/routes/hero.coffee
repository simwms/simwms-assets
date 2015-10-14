`import Ember from 'ember'`

Lion = "http://i.imgur.com/uffdii2.jpg"
Husky = "http://i.imgur.com/Xc6ba3A.jpg"
Coke = "http://i.imgur.com/ur6PH2J.jpg"
Porn = "http://i.imgur.com/Mfw78bb.png"
Male = "http://i.imgur.com/RDZhrcM.jpg"
Fat = "http://i.imgur.com/RckA4jr.jpg"

Route = Ember.Route.extend
  model: ->
    Ember.A [Lion, Husky, Coke, Porn, Male, Fat]

`export default Route`