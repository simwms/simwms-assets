`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-edge-scroll'`

MapGridEdgeScrollComponent = Ember.Component.extend(
  layout: layout
)

`export default MapGridEdgeScrollComponent`
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