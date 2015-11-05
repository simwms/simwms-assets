`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-ghost'`

{Component, computed} = Ember
{alias} = computed

product = (x, y) ->
  computed x, y,
    get: -> @get(x) * @get(y)

linear = (m, x, b, type) ->
  computed m, x, b, type,
    get: -> 
      switch @get type
        when "point"
          @get(m) * @get(x) - @get(b) / 2
        when "tile"
          @get(m) * @get(x)
        else throw new Error "I don't calculate the linear shift for #{type}"

MapGridGhostComponent = Component.extend
  tagName: "rect"
  layout: layout
  type: alias "model.ghostType"
  classNames: ["map-grid-ghost"]
  classNameBindings: ["type"]
  attributeBindings: ["x", "y", "rx", "ry", "width", "height", "transform"]
  grid: alias "parentView"
  pixelsPerLength: alias "grid.pixelsPerLength"
  snapRadius: 0.2 # grid
  x: linear "pixelsPerLength", "gx", "width", "type"
  y: linear "pixelsPerLength", "gy", "height", "type"
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
        when "tile" then 1
        when "point" then 0.15
        else 1
  
  gh: computed "type",
    get: ->
      switch @get "type"
        when "tile" then 1
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
    @set "gx", @snapX(event)
    @set "gy", @snapY(event)

  snapX: ({gridX}) -> 
    switch @get "type"
      when "point"
        snapTarget = Math.round(gridX)
        snapRadius = @get("snapRadius")
        if Math.abs(gridX - snapTarget) < snapRadius
          snapTarget
        else
          gridX
      when "tile"
        Math.floor gridX
      else gridX

  snapY: ({gridY}) ->
    switch @get "type"
      when "point"
        snapTarget = Math.round(gridY)
        snapRadius = @get("snapRadius")
        if Math.abs(gridY - snapTarget) < snapRadius
          snapTarget
        else
          gridY
      when "tile"
        Math.floor gridY
      else gridY

`export default MapGridGhostComponent`
