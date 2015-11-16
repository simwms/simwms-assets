`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-ghost'`
`import GridGhostMixin from '../mixins/grid-ghost'`
{Component, computed} = Ember
{alias, equal, and: present} = computed

product = (x, y) ->
  computed x, y,
    get: -> @get(x) * @get(y)

linear = (m, x, negb) ->
  computed m, x, negb,
    get: -> @get(m) * @get(x) - @get(negb)

MapGridGhostComponent = Component.extend GridGhostMixin,
  ghostName: "buildGhost"
  tagName: "g"
  layout: layout
  type: computed "model.ghostType",
    set: (_key, type) ->
      @refreshGhost()
      @set "model.ghostType", type
    get: -> @get "model.ghostType"
  classNames: ["map-grid-ghost"]
  classNameBindings: ["type", "active::inactive"]
  attributeBindings: ["transform"]
  snapRadius: 0.225 # grid
  pointRadius: 0.1 # grid
  r: product "pixelsPerLength", "pointRadius"
  x: alias "x0"
  y: alias "y0"
  x0: product "pixelsPerLength", "gx0"
  y0: product "pixelsPerLength", "gy0"
  active: equal "mode", "build-mode"
  mode: alias "parentView.mode"
  width: alias "pixelsPerLength"
  height: alias "pixelsPerLength"
  xf: linear "pixelsPerLength", "gxf", "x"
  yf: linear "pixelsPerLength", "gyf", "y"
  
  is1point: equal "type", "point"
  is2point: equal "type", "2point"
  isTile: equal "type", "tile"
  transform: computed "x", "y",
    get: ->
      x = @get "x"
      y = @get "y"
      "translate(#{x}, #{y})"

  ghostMouseUp: Ember.on "ghostMouseUp", (event) ->
    type = @get "type"
    switch
      when type is "point" and event.button is 0
        @sendAction "action", @get("model"), event
      when type is "tile" and event.button is 0
        @sendAction "action", @get("model"), event
      when type is "2point" and @get("onSecondPoint")
        @sendAction "action", @get("model"), @get("firstPoint"), event
        @refreshGhost()
      when type is "2point"
        @set "firstPoint", event
      else throw new Error "I'm not sure what to do, #{type}"


`export default MapGridGhostComponent`
