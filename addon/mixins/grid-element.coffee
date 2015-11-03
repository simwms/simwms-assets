`import Ember from 'ember'`

{get, A, computed, Mixin} = Ember
{alias} = computed

GridElementMixin = Mixin.create
  points: A()
  tagName: "g"
  attributeBindings: ["transform"]
  pixelsPerLength: alias "parentView.pixelsPerLength"
  origin: alias "model.origin"
  points: alias "model.points"

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

`export default GridElementMixin`
