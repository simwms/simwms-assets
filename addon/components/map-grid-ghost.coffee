`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-ghost'`

{Component, computed} = Ember
{alias} = computed

product = (x, y) ->
  computed x, y,
    get: -> @get(x) * @get(y)

linear = (m, x, b) ->
  computed m, x, b,
    get: -> @get(m) * @get(x) - @get(b) / 2

MapGridGhostComponent = Component.extend
  tagName: "rect"
  layout: layout
  type: alias "model.type"
  classNames: ["map-grid-ghost"]
  classNameBindings: ["type"]
  attributeBindings: ["x", "y", "rx", "ry", "width", "height", "transform"]
  grid: alias "parentView"
  pixelsPerLength: alias "grid.pixelsPerLength"
  snapRadius: 0.2 # grid
  x: linear "pixelsPerLength", "gx", "width"
  y: linear "pixelsPerLength", "gy", "height"
  rx: 10 # pixels 
  ry: 10 # pixels
  angle: 0 # degrees
  gx: 0 # grid
  gy: 0 # grid

  width: product "pixelsPerLength", "gw"
  height: product "pixelsPerLength", "gh"
  gw: computed "type",
    get: ->
      switch @get "type"
        when "point" then 0.15
        else 1
  
  gh: computed "type",
    get: ->
      switch @get "type"
        when "point" then 0.15
        else 1

  transform: computed "angle", "x", "y",
    get: ->
      a = @get "angle"
      x = @get "x"
      y = @get "y"
      "rotate(#{a}, #{x}, #{y})"

  willInsertElement: ->
    @get "grid"
    .registerGhost @

  willDestroyElement: ->
    @get "grid"
    .unregisterGhost @

  ghostMove: Ember.on "ghostMove", (event) ->
    @set "gx", @snapX event
    @set "gy", @snapY event

  snapX: ({gridX}) -> 
    type = @get "type"
    snapTarget = Math.round(gridX)
    snapRadius = @get("snapRadius")
    switch
      when type is "point" and Math.abs(gridX - snapTarget) < snapRadius
        snapTarget
      else gridX

  snapY: ({gridY}) ->
    type = @get "type"
    snapTarget = Math.round(gridY)
    snapRadius = @get("snapRadius")
    switch
      when type is "point" and Math.abs(gridY - snapTarget) < snapRadius
        snapTarget
      else gridY

`export default MapGridGhostComponent`
