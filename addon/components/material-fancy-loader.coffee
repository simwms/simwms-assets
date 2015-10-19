`import Ember from 'ember'`
`import layout from '../templates/components/material-fancy-loader'`

decayPrime = (t, k) ->
  if t < k
    (k / 3) * (1 - t / k)
  else
    Math.exp(-t / k)

every = (miliseconds, _, action) ->
  window.setInterval action, miliseconds

MaterialFancyLoaderComponent = Ember.Component.extend
  classNames: ["material-fancy-loader"]
  layout: layout
  tasks: Ember.A [
    "transferring local data",
    "contacting remote server",
    "interfacing proper api",
    "performing database transaction",
    "engaging data optimizer",
    "ensuring transfer integrity"
  ]
  doneIcon: "fa fa-check"
  isInFlight: false
  isBusy: false
  progressPercentage: 0
  timeTick: 0
  halfLife: 10 # half life is in units of 500 miliseconds

  isBusy: Ember.computed.alias "isInFlight"
      

  completeTasks: Ember.computed "progressIndex", "tasks.@each", ->
    i = @get "progressIndex"
    @get("tasks").slice(0, i)

  incompleteTasks: Ember.computed "progressIndex", "tasks.@each", ->
    i = @get "progressIndex"
    @get("tasks").slice(i)

  progressIndex: Ember.computed "progressPercentage", "tasks.length", ->
    Math.floor @get("tasks.length") * @get("progressPercentage") / 100

  startProgress: ->
    @set "timeTick", 0
    @interval = every 500, "ms", @incrementProgressPercentage.bind(@)

  finishProgress: ->
    window.clearInterval @interval

  incrementTimeTick: ->
    @incrementProperty "timeTick"

  incrementProgressPercentage: ->
    deltaProgress = @progressPerTime() * @incrementTimeTick()
    progress = @get("progressPercentage") 
    while Math.abs(progress) < 100 and Math.abs(progress + deltaProgress) > 99
      deltaProgress = Math.abs(deltaProgress / 2)
    @incrementProperty "progressPercentage", deltaProgress

  progressPerTime: ->
    t = @get "timeTick"
    k = @get "halfLife"
    decayPrime t, k

  willDestroyElement: ->
    @finishProgress()

  resetLoader: Ember.observer "isInFlight", ->
    if @get "isInFlight"
      @set "progressPercentage", 0
      @startProgress()
    else
      @set "progressPercentage", 100
      @finishProgress()

`export default MaterialFancyLoaderComponent`
