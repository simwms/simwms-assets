`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-edge-attachment'`

{Component, computed} = Ember
{alias} = computed

rotate = (a,x,y) ->
  "rotate(#{a}, #{x}, #{y})"

MapGridEdgeAttachmentComponent = Component.extend
  layout: layout
  tagName: "rect"
  attributeBindings: ["x", "y", "rx", "ry", "width", "height", "transform"]
  classNameBindings: ["type"]
  classNames: ["map-grid-edge-attachment"]
  origin: alias "model.origin"
  type: alias "model.type"
  c: alias "parentView.pixelsPerLength"
  angle: alias "model.angle"
  x: computed "origin.x", "c",
    get: ->
      c = @get "c"
      x = @get "origin.x"
      c * x
  y: computed "origin.y", "c",
    get: ->
      c = @get "c"
      y = @get "origin.y"
      h = @get "height"
      c * y - 0.5 * h
  width: alias "c"
  height: 10
  rx: 3
  ry: 3
  transform: computed "angle", "x", "origin.y", "c",
    get: ->
      c = @get "c"
      a = @get "angle"
      x = @get "x"
      y = c * @get "origin.y"
      rotate(a, x, y)
  click: ->
    @sendAction "action", @get("model")


`export default MapGridEdgeAttachmentComponent`
