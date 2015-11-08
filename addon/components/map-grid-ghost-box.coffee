`import Ember from 'ember'`
`import GridGhostMixin from '../mixins/grid-ghost'`
`import layout from '../templates/components/map-grid-ghost-box'`
{Component, computed, A} = Ember
{equal, alias} = computed
product = (x, y) ->
  computed x, y,
    get: -> @get(x) * @get(y)

diffprod = (x, y, k) ->
  computed x, y, k,
    get: -> @get(k) * (@get(x) - @get(y))

points = (xs...) ->
  A xs
  .map (point) -> point.join ","
  .join " "

translate = (x,y) -> "translate(#{x}, #{y})"

MapGridGhostBoxComponent = Component.extend GridGhostMixin,
  layout: layout
  tagName: "g"
  attributeBindings: ["transform"]
  classNames: ["map-grid-ghost-box"]
  classNameBindings: ["active::inactive"]
  active: equal "mode", "select-mode"
  mode: alias "parentView.mode"
  transform: computed "x", "y",
    get: ->
      translate @get("x"), @get("y")

  points: computed "width", "height",
    get: ->
      w = @get "width"
      h = @get "height"
      points([0, 0], [w, 0], [w, h], [0, h])

  x: product "gx0", "pixelsPerLength"
  y: product "gy0", "pixelsPerLength"

  width: diffprod "gxf", "gx0", "pixelsPerLength"
  height: diffprod "gyf", "gy0", "pixelsPerLength"

  ghostMove: Ember.on "ghostMove", ({gridX, gridY}) ->
    if @get "onSecondPoint"
      @set "gxf", gridX
      @set "gyf", gridY
    else
      @set "gx0", gridX
      @set "gy0", gridY

  ghostDown: Ember.on "ghostDown", (event) ->
    onFirstPoint = not @get "onSecondPoint"
    if onFirstPoint
      @set "firstPoint", event

  ghostUp: Ember.on "ghostUp", (event) ->
    onSecondPoint = @get "onSecondPoint"
    if onSecondPoint
      models = @get("parentView")?.selectModelsBetween(@get("firstPoint"), event) ? []
      @sendAction "action", models, @get("firstPoint"), event
      @refreshGhost()

  willInsertElement: ->
    @get "parentView"
    .registerGhost "selectGhost", @

`export default MapGridGhostBoxComponent`
