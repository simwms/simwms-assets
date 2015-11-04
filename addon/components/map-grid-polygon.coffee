`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-polygon'`
`import GridElement from '../mixins/grid-element'`

{Component, computed, get, A} = Ember
{alias} = computed

MapGridPolygonComponent = Component.extend GridElement,
  layout: layout
  polygonClassNames: "map-grid-polygon"
  
  classNameBindings: ["type"]
  type: alias "model.type"

  mouseUp: (event) ->
    event.childModel = @get "model"
    @get "parentView"
    ?.mouseUp?event
    return false

`export default MapGridPolygonComponent`
