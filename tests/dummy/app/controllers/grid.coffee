`import Ember from 'ember'`

{Controller, computed: {alias, equal}} = Ember

GridController = Controller.extend
  road: alias "model.road"
  house: alias "model.house"
  tile: alias "model.tile"
  door: alias "model.door"
  ghost: alias "model.ghost"
  mode: "query-mode"
  isBuildMode: equal "mode", "build-mode"
  actions:
    query: (model) ->
      console.log "query:"
      console.log model

    build: (model, e1, e2) ->
      console.log "build:"
      console.log model
      @set "lastEvent", e1

    select: (models) ->
      console.log "select:"
      console.log models

    toggleGhost: (type) ->
      @set "ghost.ghostType", type
      
    toggleMode: (mode) ->
      @set "mode", mode


`export default GridController`