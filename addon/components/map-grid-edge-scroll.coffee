`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-edge-scroll'`

{computed, isBlank, $} = Ember
{alias} = computed
MapGridEdgeScrollComponent = Ember.Component.extend
  layout: layout
  tagName: "rect"
  classNames: ["map-grid-edge-scroll"]
  attributeBindings: ["x", "y", "width", "height"]
  parentWidth: alias "parentView.width"
  parentHeight: alias "parentView.height"
  x: computed "position", "parentWidth", "parentHeight",
    get: ->
      switch @get "position"
        when "top", "bottom", "left" then 0
        when "right" then @getWithDefault("parentWidth", 75) - 75
        else throw new Error "I can't calculate x with position: #{@get "position"}"
  y: computed "position", "parentWidth", "parentHeight",
    get: ->
      switch @get "position"
        when "top", "left", "right" then 0
        when "bottom" then @getWithDefault("parentHeight", 75) - 75
        else throw new Error "I can't calculate y with position: #{@get "position"}"
  width: computed "position", "parentWidth", "parentHeight",
    get: ->
      switch @get "position"
        when "top", "bottom" then @getWithDefault("parentWidth", 0)
        when "left", "right" then 75
        else throw new Error "I can't calculate width with position: #{@get "position"}"
  height: computed "position", "parentWidth", "parentHeight",
    get: ->
      switch @get "position"
        when "top", "bottom" then 75
        when "left", "right" then @getWithDefault("parentHeight", 0)
        else throw new Error "I can't calculate height with position: #{@get "position"}"
  velocity: computed "position",
    get: ->
      switch (position = @get "position")
        when "top" then dx: 0, dy: 5
        when "bottom" then dx: 0, dy: -5
        when "left" then dx: 5, dy: 0
        when "right" then dx: -5, dy: 0
        else throw new Error "I can't calculate velocity with this shitty position #{position}"

  _hasMouse: false
  hasMouse: computed
    get: -> @_hasMouse
    set: (_, value) ->
      if (@_hasMouse = value)
        @_mouseVelocityInterval = window.setInterval @mouseVelocity.bind(@), 25
      else
        window.clearInterval @_mouseVelocityInterval

  willDestroyElement: ->
    window.clearInterval @_mouseVelocityInterval

  mouseEnter: ->
    @set "hasMouse", true
    true

  mouseLeave: ->
    @set "hasMouse", false
    true

  mouseVelocity: ->
    @get "parentView"
    ?.drag @get "velocity"
  

`export default MapGridEdgeScrollComponent`
