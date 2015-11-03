`import Ember from 'ember'`

{computed, isBlank, Mixin, Object: O} = Ember

GridInteractionMixin = Mixin.create
  translateX: 0
  translateY: 0
  _interactionMode: "select-mode"
  interactionMode: computed
    get: -> @_interactionMode
    set: (_key, newMode) ->
      oldMode = @_interactionMode
      switch
        when newMode is oldMode 
          @_interactionMode = newMode
        when newMode is "select-mode" and oldMode is "drag-mode"
          @origin = null
          @_interactionMode = newMode
        when newMode is "drag-mode" and oldMode is "select-mode"
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

  drag: ({dx, dy}) ->
    @incrementProperty "translateX", dx
    @incrementProperty "translateY", dy

  selectModeMouse: ->
    # @incrementProperty "translateX", dx / 2
    # @incrementProperty "translateY", dy / 2

  ## Actual Events  
  touchMove: ->
    alert "touch moved"
  
  mouseDown: (event) ->
    if event.button is 0
      @set "interactionMode", "drag-mode"

  mouseMove: (event) ->
    switch @get "interactionMode"
      when "drag-mode" then @dragModeMouse(event)
      when "select-mode" then @selectModeMouse(event)
      when null then throw new Error("Ember is stupid")
      else return

  mouseUp: (event) ->
    if event.button is 0
      @set "interactionMode", "select-mode"

  mouseLeave: ->
    @set "interactionMode", "select-mode"

`export default GridInteractionMixin`
