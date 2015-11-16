`import Ember from 'ember'`
`import multimerge from '../utils/multimerge'`
`import Geometry from '../utils/geometry'`

{getWithDefault, get, A, computed, isEmpty, isPresent, isBlank, Mixin, Object: O} = Ember
{filterBy} = computed

KnownModes = ["query-mode", "select-mode", "batch-mode", "build-mode", "drag-mode"]
Kernel =
  registerGhost: (name, ghost) ->
    @set name, ghost

  unregisterGhost: (name) ->
    @set name, null

  calculateGridPosition: (event, ghost) ->
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
    if ghost?
      event.snapGridX = ghost.get "gx"
      event.snapGridY = ghost.get "gy"
      event.snapGridRelX = event.snapGridX - ox
      event.snapGridRelY = event.snapGridY - oy
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
        when "drag-mode" then @tearDownDragMode?oldMode
        when "query-mode" then @tearDownQueryMode?oldMode
        when "build-mode" then @tearDownBuildMode?oldMode
        when "select-mode" then @tearDownSelectMode?oldMode
        when "batch-mode" then @tearDownBatchMode?oldMode
        else throw new Error("I don't know how tear down '#{oldMode}'")
      switch newMode
        when "drag-mode" then @setupDragMode?oldMode
        when "query-mode" then @setupQueryMode?oldMode
        when "build-mode" then @setupBuildMode?oldMode
        when "select-mode" then @setupSelectMode?oldMode
        when "batch-mode" then @setupBatchMode?oldMode
        else throw new Error("I don't know how to set up '#{newMode}'")
      @_interactionMode = newMode

  click: (event) ->
    switch @get "interactionMode"
      when "query-mode" then @queryModeClick(event)
      else return

  mouseDown: (event) ->
    switch @get "interactionMode"
      when "query-mode" then @queryModeMouseDown(event)
      when "select-mode" then @selectModeMouseDown(event)
      when "batch-mode" then @batchModeMouseDown(event)
      else return

  mouseMove: (event) ->
    switch @get "interactionMode"
      when "drag-mode" then @dragModeMouseMove(event)
      when "select-mode" then @selectModeMouseMove(event)
      when "build-mode" then @buildModeMouseMove(event)
      when "batch-mode" then @batchModeMouseMove(event)
      when null then throw new Error("Ember is stupid")
      else return

  mouseUp: (event) ->
    switch @get "interactionMode"
      when "drag-mode" then @dragModeMouseUp(event)
      when "select-mode" then @selectModeMouseUp(event)
      when "build-mode" then @buildModeMouseUp(event)
      when "batch-mode" then @batchModeMouseUp(event)
      else return

QueryMode =
  queryModeMouseDown: (event) ->
    if event.button is 0
      @set "interactionMode", "drag-mode"
  queryModeClick: (event) ->
    if event.childModel?
      @sendAction "action", event.childModel, event

modelWithinRect = (rect) ->
  (component) -> 
    Geometry.componentOverlapsShape(component, rect)

makeRect = ({gridX: x0, gridY: y0}, {gridX: xf, gridY: yf}) ->
  [[x0, y0], [xf, y0], [xf, yf], [x0, yf]]

deselectComponent = (component) ->
  return unless component?
  return if get(component, "isDestroyed")
  component.set "selected", false

SelectMode =
  setupSelectMode: ->
    @get("selectGhost")?.refreshGhost()
    @get "selectedComponents"
    .map deselectComponent
      
  tearDownSelectMode: ->
    @get("selectGhost")?.refreshGhost()

  selectableComponents: A []
  selectedComponents: filterBy "selectableComponents", "selected"
  registerSelectable: (component) ->
    @get("selectableComponents").pushObject component

  unregisterSelectable: (component) ->
    @get("selectableComponents").removeObject component

  selectModelsBetween: (e1, e2) ->
    @get("selectableComponents")
    .filter modelWithinRect(makeRect e1, e2)
    .map (component) -> component.set "selected", true
    if @getWithDefault("selectedComponents.length", 0) > 0
      @set "interactionMode", "batch-mode"

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

BatchMode =
  setupBatchMode: ->
    @get("batchGhost")?.refreshGhost()
  tearDownBatchMode: ->
    @get("batchGhost")?.refreshGhost()
    @get "selectedComponents"
    .map deselectComponent

  batchModeMouseDown: (event) ->
    if event.button is 0 and (ghost = @get "batchGhost")?
      e = @calculateGridPosition(event, ghost)
      Ember.sendEvent ghost, "ghostDown", [e]

  batchModeMouseMove: (event) ->
    if (ghost = @get "batchGhost")?
      e = @calculateGridPosition(event, ghost)
      Ember.sendEvent ghost, "ghostMove", [e]    

  batchModeMouseUp: (event) ->
    ghost = @get "batchGhost"
    if event.button is 0 and ghost?
      e = @calculateGridPosition(event, ghost)
      Ember.sendEvent ghost, "ghostUp", [e]
      @set "interactionMode", "select-mode"

BuildMode =
  setupBuildMode: ->
    @get("buildGhost")?.refreshGhost()
  tearDownBuildMode: ->
    @get("buildGhost")?.refreshGhost()

  buildModeMouseMove: (event) ->
    if isPresent(ghost = @get "buildGhost")
      e = @calculateGridPosition event, ghost
      Ember.sendEvent ghost, "ghostMove", [e]

  buildModeMouseUp: (event) ->
    if isPresent(ghost = @get "buildGhost")
      e = @calculateGridPosition event, ghost
      Ember.sendEvent ghost, "ghostMouseUp", [e]

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
    x = @get "translateX"
    y = @get "translateY"
    width = @getWithDefault "dimensions.width", 1
    height = @getWithDefault "dimensions.height", 1
    viewportWidth = @getWithDefault("width", 0) - 75
    viewportHeight = @getWithDefault("height", 0) - 75
    k = @getWithDefault "pixelsPerLength", 1

    if (viewportWidth - width * k) < x + dx < 75
      @incrementProperty "translateX", dx
    if (viewportHeight - height * k) < y + dy < 75
      @incrementProperty "translateY", dy
GridInteractionMixin = Mixin.create multimerge Kernel, QueryMode, SelectMode, BatchMode, BuildMode, DragMode

`export default GridInteractionMixin`
