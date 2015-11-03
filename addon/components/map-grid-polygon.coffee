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

  actions:
    interact: ->
      @sendAction "action", @get("model")

`export default MapGridPolygonComponent`
