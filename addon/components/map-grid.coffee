`import Ember from 'ember'`
`import layout from '../templates/components/map-grid'`
`import GridInteraction from '../mixins/grid-interaction'`

{Component, computed, Object: O} = Ember

Line = O.extend
  stroke: "#444"
  strokeWidth: "1"

MapGridComponent = Component.extend GridInteraction,
  layout: layout
  tagName: "svg"
  classNames: ["map-grid"]
  classNameBindings: ["interactionMode"]
  dimensions:
    width: 20
    height: 20
  gridVisible: true
  pixelsPerLength: 75
  attributeBindings: ["draggable"]
  draggable: true

  lines: computed "dimensions.width", "dimensions.height", "pixelsPerLength",
    get: ->
      lines = Ember.A()
      width = @get "dimensions.width"
      height = @get "dimensions.height"
      for x in [0..width]
        lines.pushObject @makeLineFrom(x0: x, y0: 0).to(xf: x, yf: height)
      for y in [0..height]
        lines.pushObject @makeLineFrom(x0: 0, y0: y).to(xf: width, yf: y)
      lines

  makeLineFrom: ({x0, y0}) ->
    k = @get "pixelsPerLength"
    to: ({xf, yf}) ->
      Line.create
        x1: x0 * k
        y1: y0 * k
        x2: xf * k
        y2: yf * k

`export default MapGridComponent`
