`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-polygon'`
`import GridElement from '../mixins/grid-element'`

{Component, computed, get, A} = Ember
{alias} = computed

MapGridPolygonComponent = Component.extend GridElement,
  layout: layout
  polygonClassNames: "map-grid-polygon"
  shapeType: "polygon"

`export default MapGridPolygonComponent`
