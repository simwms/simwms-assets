`import Ember from 'ember'`
`import multimerge from '../utils/multimerge'`

{getWithDefault, computed, isPresent, isBlank, Mixin, Object: O} = Ember

Kernel =
  translateX: 0
  translateY: 0
  _interactionMode: "select-mode"
  interactionMode: computed
    get: -> @_interactionMode
    set: (_key, newMode) ->
      oldMode = @_interactionMode
      return oldMode if oldMode is newMode
      switch oldMode
        when "build-mode" then @tearDownBuildMode?oldMode
        when "select-mode" then @tearDownSelectMode?oldMode
        when "drag-mode" then @tearDownDragMode?oldMode
        else throw new Error("I don't know how tear down '#{oldMode}'")
      switch newMode
        when "build-mode" then @setupBuildMode?oldMode
        when "select-mode" then @setupSelectMode?oldMode
        when "drag-mode" then @setupDragMode?oldMode
        else throw new Error("I don't know how to set up '#{newMode}'")
      @_interactionMode = newMode
        
  mouseDown: (event) ->
    switch @get "interactionMode"
      when "select-mode" then @selectModeMouseDown(event)
      else return

  mouseMove: (event) ->
    switch @get "interactionMode"
      when "drag-mode" then @dragModeMouseMove(event)
      when "build-mode" then @buildModeMouseMove(event)
      when null then throw new Error("Ember is stupid")
      else return

  mouseUp: (event) ->
    switch @get "interactionMode"
      when "drag-mode" then @dragModeMouseUp(event)
      when "build-mode" then @buildModeMouseUp(event)
      else return

  mouseLeave: ->
    switch @get "interactionMode"
      when "drag-mode" then @dragModeMouseLeave(event)
      else  return

SelectMode =
  selectModeMouseDown: (event) ->
    if event.button is 0
      @set "interactionMode", "drag-mode"

DragMode =
  setupDragMode: ->
    @origin = null
  tearDownDragMode: ->
    @origin = null

  canvasTransform: computed "translateX", "translateY", 
    get: ->
      x = @get "translateX"
      y = @get "translateY"
      "translate(#{x}, #{y})"

  calculateDragDelta: ({offsetX, offsetY}) ->
    if @origin?
      delta = 
        dx: offsetX - @origin.x
        dy: offsetY - @origin.y
      @origin =
        x: offsetX
        y: offsetY
      delta
    else
      @origin =
        x: offsetX
        y: offsetY
      dx: 0, dy: 0

  dragModeMouseUp: (event) ->
    if event.button is 0
      @set "interactionMode", "select-mode"

  dragModeMouseLeave: (event) ->
    @set "interactionMode", "select-mode"

  dragModeMouseMove: (event) ->
    if (delta = @calculateDragDelta event)
      @drag(delta) 

  drag: ({dx, dy}) ->
    @incrementProperty "translateX", dx
    @incrementProperty "translateY", dy

BuildMode =
  registerGhost: (ghost) ->
    @set "buildGhost", ghost

  unregisterGhost: (ghost) ->
    @set "buildGhost", null

  buildModeMouseMove: (event) ->
    if isPresent(ghost = @get "buildGhost")
      e = @calculateGridPosition event
      Ember.sendEvent ghost, "ghostMove", [e]

  buildModeMouseUp: (event) ->
    if event.button is 0
      @sendAction "action", @calculateGridPosition(event)

  calculateGridPosition: (event) ->
    {offsetX: x0, offsetY: y0, childModel: cm} = event
    ox = if cm? then getWithDefault(cm, "origin.x", 0) else 0
    oy = if cm? then getWithDefault(cm, "origin.y", 0) else 0
    dx = @get "translateX"
    dy = @get "translateY"
    k = @get "pixelsPerLength"
    event.gridX = (x0 - dx) / k
    event.gridY = (y0 - dy) / k
    event.gridRelX = event.gridX - ox
    event.gridRelY = event.gridY - oy
    event.snapGridX = @get "buildGhost.gx"
    event.snapGridY = @get "buildGhost.gy"
    event.snapGridRelX = event.snapGridX - ox
    event.snapGridRelY = event.snapGridY - oy
    event

GridInteractionMixin = Mixin.create multimerge Kernel, SelectMode, DragMode, BuildMode

`export default GridInteractionMixin`
