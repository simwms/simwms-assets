`import Ember from 'ember'`

{Controller, computed: {alias, equal}} = Ember

GridController = Controller.extend
  road: alias "model.road"
  house: alias "model.house"
  tile: alias "model.tile"
  door: alias "model.door"

  mode: "build-mode"
  isBuildMode: equal "mode", "build-mode"
  actions:
    build: ({gridX, gridY, gridRelX, gridRelY}) ->
      console.log "grid@(#{gridX}, #{gridY})"
      console.log "rel@(#{gridRelX}, #{gridRelY})"
      
    toggleMode: ->
      switch @get "mode"
        when "select-mode"
          @set "mode", "build-mode"
        else 
          @set "mode", "select-mode"


`export default GridController`