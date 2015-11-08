`import Ember from 'ember'`

{Mixin, computed} = Ember
{alias, equal, and: present} = computed

ifThenElse = (check, x, y) ->
  computed check, x, y,
    get: -> if @get(check) then @get(x) else @get(y)

GridGhostMixin = Mixin.create
  ## Defaults
  gx0: 0 # grid
  gy0: 0 # grid
  gxf: 0 # grid
  gyf: 0 # grid

  ## Computed
  onSecondPoint: present "firstPoint"
  gx: ifThenElse "onSecondPoint", "gxf", "gx0"
  gy: ifThenElse "onSecondPoint", "gyf", "gy0"
  grid: alias "parentView"
  pixelsPerLength: alias "grid.pixelsPerLength"

  ## Api
  refreshGhost: ->
    @set "firstPoint", null

  ghostMove: Ember.on "ghostMove", ({gridX, gridY}) ->
    if @get "onSecondPoint"
      @set "gxf", @snap(gridX)
      @set "gyf", @snap(gridY)
    else
      @set "gx0", @snap(gridX)
      @set "gy0", @snap(gridY)

  ## Private
  snap: (originalValue) -> 
    snapTarget = Math.round(originalValue)
    snapRadius = @getWithDefault("snapRadius", 0)
    if Math.abs(originalValue - snapTarget) < snapRadius
      snapTarget
    else
      originalValue

`export default GridGhostMixin`