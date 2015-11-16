`import Ember from 'ember'`
`import GridGhostMixin from '../mixins/grid-ghost'`
`import layout from '../templates/components/map-grid-ghost-batch'`

{computed} = Ember
{equal, alias, mapBy} = computed

product = (x, y) ->
  computed x, y,
    get: -> @get(x) * @get(y)

linear = (m, x, negb) ->
  computed m, x, negb,
    get: -> @get(m) * @get(x) - @get(negb)

translate = (x,y) -> "translate(#{x}, #{y})"

MapGridGhostBatchComponent = Ember.Component.extend GridGhostMixin,
  ghostName: "batchGhost"
  layout: layout
  tagName: "g"
  attributeBindings: ["transform"]
  classNames: ["map-grid-ghost-batch"]
  classNameBindings: ["active::inactive"]
  dragState: false
  active: equal "mode", "batch-mode"
  mode: alias "parentView.mode"
  transform: computed "x", "y",
    get: ->
      translate @get("x"), @get("y")
  x: product "gx0", "pixelsPerLength"
  y: product "gy0", "pixelsPerLength"
  xf: linear "pixelsPerLength", "gxf", "x"
  yf: linear "pixelsPerLength", "gyf", "y"
  r: 5
  snapRadius: 0.25

  selectedOrigins: mapBy "parentView.selectedComponents", "model.origin"
  selectedGhosts: computed "selectedOrigins.[]", "ghostTransform",
    get: ->
      @get("selectedOrigins").map @get "ghostTransform"

  ghostTransform: computed "pixelsPerLength", "gx0", "gy0", "xf", "yf",
    get: -> 
      k = @get "pixelsPerLength"
      gx0 = @get "gx0"
      gy0 = @get "gy0"
      xf = @get "xf"
      yf = @get "yf"
      ({x,y}) ->
        cx: (x - gx0) * k + xf
        cy: (y - gy0) * k + yf

  ghostMove: Ember.on "ghostMove", ({gridX, gridY}) ->
    if @get "dragState"
      @set "gxf", @snap(gridX)
      @set "gyf", @snap(gridY)
      
  ghostDown: Ember.on "ghostDown", (event) ->
    @set "dragState", true
    {gridX, gridY} = event
    @set "gx0", @snap(gridX)
    @set "gy0", @snap(gridY)
    @set "firstPoint", event
  
  ghostUp: Ember.on "ghostUp", (event) ->
    @set "dragState", false
    models = @getWithDefault("parentView.selectedComponents", []).mapBy "model"
    @sendAction "action", models, @get("firstPoint"), event

  refreshGhost: ->
    @_super arguments...
    @set "dragState", false


`export default MapGridGhostBatchComponent`
