`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-tile'`

{computed} = Ember
{alias, and: present} = computed

MapGridTileComponent = Ember.Component.extend
  shapeType: "tile"
  tagName: "g"
  layout: layout
  iconText: alias "model.iconText"
  classNames: ["map-grid-tile"]
  classNameBindings: ["type", "selected", "tileType"]
  selected: false
  hasTileImage: present "model.tileImage"
  type: alias "model.type"
  tileType: alias "model.tileType"
  attributeBindings: ["transform"]
  pixelsPerLength: alias "parentView.pixelsPerLength"
  origin: alias "model.origin"
  halfLength: computed "pixelsPerLength",
    get: ->
      0.5 * @get "pixelsPerLength"

  transform: computed "origin.x", "origin.y", "pixelsPerLength", "origin.a",
    get: ->
      k = @get "pixelsPerLength"
      x = @get "origin.x"
      y = @get "origin.y"
      a = @getWithDefault "origin.a", 0
      "translate(#{x * k}, #{y * k}) rotate(#{a}, #{0.5*k}, #{0.5*k})"

  click: ->
    @sendAction "action", @get("model")

  willInsertElement: ->
    @get("parentView")
    ?.registerSelectable @

  willDestroyElement: ->
    @get("parentView")
    ?.unregisterSelectable @

`export default MapGridTileComponent`
