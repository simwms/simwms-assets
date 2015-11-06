`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-ghost'`

{Component, computed} = Ember
{alias, equal, and: present} = computed

product = (x, y) ->
  computed x, y,
    get: -> @get(x) * @get(y)

ifThenElse = (check, x, y) ->
  computed check, x, y,
    get: -> if @get(check) then @get(x) else @get(y)

linear = (m, x, negb) ->
  computed m, x, negb,
    get: -> @get(m) * @get(x) - @get(negb)

MapGridGhostComponent = Component.extend
  tagName: "g"
  layout: layout
  type: computed "model.ghostType",
    set: (_key, type) ->
      @refreshGhost()
      @set "model.ghostType", type
    get: -> @get "model.ghostType"
  classNames: ["map-grid-ghost"]
  classNameBindings: ["type"]
  attributeBindings: ["transform"]
  grid: alias "parentView"
  pixelsPerLength: alias "grid.pixelsPerLength"
  snapRadius: 0.225 # grid
  pointRadius: 0.1 # grid
  r: product "pixelsPerLength", "pointRadius"
  x: alias "x0"
  y: alias "y0"
  x0: product "pixelsPerLength", "gx0"
  y0: product "pixelsPerLength", "gy0"
  gx: ifThenElse "onSecondPoint", "gxf", "gx0"
  gy: ifThenElse "onSecondPoint", "gyf", "gy0"
  gx0: 0 # grid
  gy0: 0 # grid
  gxf: 0 # grid
  gyf: 0 # grid
  width: alias "pixelsPerLength"
  height: alias "pixelsPerLength"
  xf: linear "pixelsPerLength", "gxf", "x"
  yf: linear "pixelsPerLength", "gyf", "y"
  onSecondPoint: present "firstPoint"
  is1point: equal "type", "point"
  is2point: equal "type", "2point"
  isTile: equal "type", "tile"
  transform: computed "x", "y",
    get: ->
      x = @get "x"
      y = @get "y"
      "translate(#{x}, #{y})"

  willInsertElement: ->
    @get "grid"
    .registerGhost @

  willDestroyElement: ->
    @get "grid"
    .unregisterGhost @

  ghostMouseUp: Ember.on "ghostMouseUp", (event) ->
    type = @get "type"
    switch
      when type is "point" and event.button is 0
        @sendAction "action", event
      when type is "tile" and event.button is 0
        @sendAction "action", event
      when type is "2point" and @get("onSecondPoint")
        @sendAction "action", @get("firstPoint"), event
        @refreshGhost()
      when type is "2point"
        @set "firstPoint", event
      else throw new Error "I'm not sure what to do, #{type}"

  ghostMove: Ember.on "ghostMove", ({gridX, gridY}) ->
    if @get "onSecondPoint"
      @set "gxf", @snap(gridX)
      @set "gyf", @snap(gridY)
    else
      @set "gx0", @snap(gridX)
      @set "gy0", @snap(gridY)

  snap: (originalValue) -> 
    snapTarget = Math.round(originalValue)
    snapRadius = @get("snapRadius")
    if Math.abs(originalValue - snapTarget) < snapRadius
      snapTarget
    else
      originalValue

  refreshGhost: ->
    @set "firstPoint", null

`export default MapGridGhostComponent`
