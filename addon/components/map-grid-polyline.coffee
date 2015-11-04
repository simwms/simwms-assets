`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-polyline'`
`import GridElement from '../mixins/grid-element'`

{Component, computed, get, A} = Ember
{alias} = computed

MapGridPolylineComponent = Ember.Component.extend GridElement,
  layout: layout
  classNameBindings: ["type"]
  type: alias "model.type"

`export default MapGridPolylineComponent`