`import Ember from 'ember'`

{Controller, computed: {alias, equal}} = Ember

GridController = Controller.extend
  road: alias "model.road"
  house: alias "model.house"
  tile: alias "model.tile"
  door: alias "model.door"
  ghost: alias "model.ghost"
  mode: "build-mode"
  isBuildMode: equal "mode", "build-mode"
  actions:
    build: (event) ->
      @set "lastEvent", event
      
    toggleMode: ->
      switch @get "mode"
        when "select-mode"
          @set "mode", "build-mode"
        else 
          @set "mode", "select-mode"


`export default GridController`