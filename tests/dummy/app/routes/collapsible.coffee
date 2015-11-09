`import Ember from 'ember'`

{Route, Object} = Ember
CollapsibleRoute = Route.extend
  queryParams:
    e:
      refreshModel: false
  model: ->

`export default CollapsibleRoute`