`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-tile'`

{computed} = Ember
{alias} = computed

MapGridTileComponent = Ember.Component.extend
  tagName: "g"
  layout: layout
  iconText: "x"
  classNames: ["map-grid-tile"]
  classNameBindings: ["type"]
  type: alias "model.type"
  attributeBindings: ["transform"]
  pixelsPerLength: alias "parentView.pixelsPerLength"
  origin: alias "model.origin"
  stroke:
    width: 2
    color: "#212121"
  fill: "#eee"
  halfLength: computed "pixelsPerLength",
    get: ->
      0.5 * @get "pixelsPerLength"

  transform: computed "origin.x", "origin.y", "pixelsPerLength",
    get: ->
      k = @get "pixelsPerLength"
      x = @get "origin.x"
      y = @get "origin.y"
      "translate(#{x * k}, #{y * k})"

  click: ->
    @sendAction "action", @get("model")

`export default MapGridTileComponent`
