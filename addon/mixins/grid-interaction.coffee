`import Ember from 'ember'`

{getWithDefault, computed, isBlank, Mixin, Object: O} = Ember

GridInteractionMixin = Mixin.create
  translateX: 0
  translateY: 0
  _interactionMode: "select-mode"
  interactionMode: computed
    get: -> @_interactionMode
    set: (_key, newMode) ->
      oldMode = @_interactionMode
      switch newMode
        when oldMode 
          @_interactionMode = newMode
        when "build-mode"
          @_interactionMode = newMode
        when "select-mode"
          @origin = null
          @_interactionMode = newMode
        when "drag-mode"
          @origin = null
          @_interactionMode = newMode
        else throw new Error("I don't know how to go from '#{oldMode}' to '#{newMode}'")

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

  dragModeMouse: (event) ->
    if (delta = @calculateDragDelta event)
      @drag(delta) 

  buildModeMouse: (event) ->

  drag: ({dx, dy}) ->
    @incrementProperty "translateX", dx
    @incrementProperty "translateY", dy

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

  ## Actual Events  
  touchMove: ->
    alert "touch moved"
  
  mouseDown: (event) ->
    switch @get "interactionMode"
      when "select-mode"
        if event.button is 0
          @set "interactionMode", "drag-mode"
      else return

  mouseMove: (event) ->
    switch @get "interactionMode"
      when "drag-mode" then @dragModeMouse(event)
      when "build-mode" then @buildModeMouse(event)
      when null then throw new Error("Ember is stupid")
      else return

  mouseUp: (event) ->
    switch @get "interactionMode"
      when "drag-mode"
        if event.button is 0
          @set "interactionMode", "select-mode"
      when "build-mode"
        if event.button is 0
          @sendAction "action", @calculateGridPosition(event)
      else return

  mouseLeave: ->
    @set "interactionMode", "select-mode"

`export default GridInteractionMixin`
