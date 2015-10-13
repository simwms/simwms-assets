`import Ember from 'ember'`

Route = Ember.Route.extend
  model: ->
    @modelFor("cards").slice(0, 4)

`export default Route`