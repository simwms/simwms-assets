`import Ember from 'ember'`

Route = Ember.Route.extend
  model: ->
    @modelFor("cards").slice(0, 3)

`export default Route`