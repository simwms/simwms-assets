`import Ember from 'ember'`
`import multimerge from '../utils/multimerge'`
`import Geometry from '../utils/geometry'`

{getWithDefault, A, computed, isPresent, isBlank, Mixin, Object: O} = Ember
KnownModes = ["query-mode", "select-mode", "drag-mode", "build-mode"]
Kernel =
  registerGhost: (name, ghost) ->
    @set name, ghost

  unregisterGhost: (name) ->
    @set name, null

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
    event

  translateX: 0
  translateY: 0
  _interactionMode: "query-mode"
  interactionMode: computed
    get: -> @_interactionMode
    set: (_key, newMode) ->
      @_defaultMode = newMode if isBlank @_defaultMode
      oldMode = @_interactionMode
      return oldMode if oldMode is newMode
      switch oldMode
        when "query-mode" then @tearDownQueryMode?oldMode
        when "build-mode" then @tearDownBuildMode?oldMode
        when "select-mode" then @tearDownSelectMode?oldMode
        when "drag-mode" then @tearDownDragMode?oldMode
        else throw new Error("I don't know how tear down '#{oldMode}'")
      switch newMode
        when "query-mode" then @setupQueryMode?oldMode
        when "build-mode" then @setupBuildMode?oldMode
        when "select-mode" then @setupSelectMode?oldMode
        when "drag-mode" then @setupDragMode?oldMode
        else throw new Error("I don't know how to set up '#{newMode}'")
      @_interactionMode = newMode

  click: (event) ->
    switch @get "interactionMode"
      when "query-mode" then @queryModeClick(event)
      else return

  mouseDown: (event) ->
    switch @get "interactionMode"
      when "select-mode" then @selectModeMouseDown(event)
      when "query-mode" then @queryModeMouseDown(event)
      else return

  mouseMove: (event) ->
    switch @get "interactionMode"
      when "select-mode" then @selectModeMouseMove(event)
      when "drag-mode" then @dragModeMouseMove(event)
      when "build-mode" then @buildModeMouseMove(event)
      when null then throw new Error("Ember is stupid")
      else return

  mouseUp: (event) ->
    switch @get "interactionMode"
      when "select-mode" then @selectModeMouseUp(event)
      when "drag-mode" then @dragModeMouseUp(event)
      when "build-mode" then @buildModeMouseUp(event)
      else return

  mouseLeave: ->
    switch @get "interactionMode"
      when "drag-mode" then @dragModeMouseLeave(event)
      else return


QueryMode =
  queryModeMouseDown: (event) ->
    if event.button is 0
      @set "interactionMode", "drag-mode"

  queryModeClick: (event) ->
    if event.childModel?
      @sendAction "action", event.childModel, event

modelWithinRect = (rect) ->
  (model) -> 
    Geometry.modelOverlapsShape(model, rect)

makeRect = ({gridX: x0, gridY: y0}, {gridX: xf, gridY: yf}) ->
  [[x0, y0], [xf, y0], [xf, yf], [x0, yf]]

SelectMode =
  setupSelectMode: ->
    @get("selectGhost")?.refreshGhost()
  tearDownSelectMode: ->
    @get("selectGhost")?.refreshGhost()

  selectableModels: A []
  registerSelectable: (model) ->
    @get("selectableModels").pushObject model

  unregisterSelectable: (model) ->
    @get("selectableModels").removeObject model

  selectModelsBetween: (e1, e2) ->
    @getWithDefault("selectableModels", [])
    .filter modelWithinRect(makeRect e1, e2)

  selectModeMouseMove: (event) ->
    if (ghost = @get "selectGhost")?
      e = @calculateGridPosition(event)
      Ember.sendEvent ghost, "ghostMove", [e]

  selectModeMouseUp: (event) ->
    ghost = @get "selectGhost"
    if event.button is 0 and ghost?
      e = @calculateGridPosition(event)
      Ember.sendEvent ghost, "ghostUp", [e]

  selectModeMouseDown: (event) ->
    ghost = @get "selectGhost"
    {button} = event
    if button is 0 and ghost? # left mouse
      e = @calculateGridPosition(event)
      Ember.sendEvent ghost, "ghostDown", [e]

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
      @set "interactionMode", "query-mode"

  dragModeMouseLeave: (event) ->
    @set "interactionMode", "query-mode"

  dragModeMouseMove: (event) ->
    if (delta = @calculateDragDelta event)
      @drag(delta) 

  drag: ({dx, dy}) ->
    @incrementProperty "translateX", dx
    @incrementProperty "translateY", dy

BuildMode =
  setupBuildMode: ->
    @get("buildGhost")?.refreshGhost()
  tearDownBuildMode: ->
    @get("buildGhost")?.refreshGhost()

  buildModeMouseMove: (event) ->
    if isPresent(ghost = @get "buildGhost")
      e = @calculateSnapGridPosition event
      Ember.sendEvent ghost, "ghostMove", [e]

  buildModeMouseUp: (event) ->
    if isPresent(ghost = @get "buildGhost")
      e = @calculateSnapGridPosition event
      Ember.sendEvent ghost, "ghostMouseUp", [e]

  calculateSnapGridPosition: (event) ->
    event = @calculateGridPosition(event)
    {childModel: cm} = event
    ox = if cm? then getWithDefault(cm, "origin.x", 0) else 0
    oy = if cm? then getWithDefault(cm, "origin.y", 0) else 0
    event.snapGridX = @get "buildGhost.gx"
    event.snapGridY = @get "buildGhost.gy"
    event.snapGridRelX = event.snapGridX - ox
    event.snapGridRelY = event.snapGridY - oy
    event

GridInteractionMixin = Mixin.create multimerge Kernel, QueryMode, SelectMode, DragMode, BuildMode

`export default GridInteractionMixin`
