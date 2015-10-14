`import Ember from 'ember'`
`import layout from '../templates/components/material-hero'`

{computed, observer} = Ember
{map} = computed

makeSegment = (scrollLeft) ->
  Ember.Object.create {scrollLeft}

log = (x) ->
  console.log x
  x

MaterialHeroComponent = Ember.Component.extend
  layout: layout
  size: "big"
  classNames: ["material-hero"]
  classNameBindings: ["materialSizeClass"]
  scrollWidth: 0
  clientWidth: 0
  milisecondsPerScroll: 5000

  materialSizeClass: computed "size",
    get: ->
      switch @get "size"
        when "large", "big" then "material-big-hero"
        when "medium", "med" then "material-med-hero"
        when "small", "slice", "sliver" then "material-small-hero"
  didInsertElement: ->
    self = @
    @$(".material-hero-image").load ->
      self.set "clientWidth", self.$().width()
      self.incrementProperty "scrollWidth", self.$(@).width()

  willDestroyElement: ->
    @killAutoScroll()

  killAutoScroll: ->
    window.clearInterval @interval

  autoscroll: observer "milisecondsPerScroll", "segments.[]", ->
    @killAutoScroll() 
    return unless 0 < @get("milisecondsPerScroll") < Infinity
    @interval = window.setInterval @scrollNext.bind(@), @get("milisecondsPerScroll")

  segments: computed "scrollWidth", "clientWidth",
    get: ->
      scrollWidth = @getWithDefault("scrollWidth", 1)
      clientWidth = @getWithDefault("clientWidth", 1)
      fullWidth = scrollWidth - clientWidth
      segments = Ember.A()
      return segments if fullWidth <= 0
      for x in [0..fullWidth] by clientWidth
        segments.pushObject makeSegment x
      if fullWidth % clientWidth > clientWidth / 4
        segments.pushObject makeSegment fullWidth
      @scrollToSegment segments.get("firstObject")
      segments

  scrollNext: ->
    activeSegment = @get("activeSegment") ? @get("segments.firstObject")
    return if Ember.isBlank activeSegment
    index = @get("segments").indexOf activeSegment
    return if index < 0
    index = (index + 1) % @getWithDefault("segments.length", 1)
    @scrollToSegment @get("segments").objectAt(index)

  scrollToSegment: (segment) ->
    @get("activeSegment")?.set("active", false)
    @$(".material-hero-images-collection").animate 
      scrollLeft: segment.get("scrollLeft")
    segment.set("active", true)
    @set "activeSegment", segment

  actions:
    scrollTo: (segment) ->
      @set "milisecondsPerScroll", 0
      @scrollToSegment segment

`export default MaterialHeroComponent`
