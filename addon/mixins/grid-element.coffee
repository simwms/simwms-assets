`import Ember from 'ember'`

{get, A, computed, Mixin} = Ember
{alias} = computed

GridElementMixin = Mixin.create
  points: A()
  tagName: "g"
  classNameBindings: ["selected", "type", "mode"]
  type: alias "model.type"
  mode: alias "parentView.mode"
  selected: false
  attributeBindings: ["transform"]
  pixelsPerLength: alias "parentView.pixelsPerLength"
  origin: alias "model.origin"
  points: alias "model.points"

  mouseUp: (event) ->
    event.childModel = @get "model"
    @get "parentView"
    .mouseUp?event
    return false

  mouseMove: (event) ->
    event.childModel = @get "model"
    @get "parentView"
    .mouseMove?event
    return false

  click: (event) ->
    event.childModel = @get "model"
    @get "parentView"
    .click?event
    return false    

  transform: computed "origin.x", "origin.y", "pixelsPerLength",
    get: ->
      k = @get "pixelsPerLength"
      x = @get "origin.x"
      y = @get "origin.y"
      "translate(#{x * k}, #{y * k})"

  pointsString: computed "points.[]", "pixelsPerLength",
    get: ->
      k = @get "pixelsPerLength"
      @get "points"
      .map (point) -> "#{k * get(point, "x")},#{k * get(point, "y")}"
      .join " "

  willInsertElement: ->
    @get("parentView")
    ?.registerSelectable @

  willDestroyElement: ->
    @get("parentView")
    ?.unregisterSelectable @

`export default GridElementMixin`
