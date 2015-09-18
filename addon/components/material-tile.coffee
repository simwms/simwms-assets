`import Ember from 'ember'`
`import layout from '../templates/components/material-tile'`

MaterialTileComponent = Ember.Component.extend
  layout: layout
  classNames: ["col", "s6", "m4", "l3", "material-tile", "waves-light", "waves-effect"]
  attributeBindings: ["style"]
  style: Ember.computed "background", ->
    imageLink = @get("background")
    return if Ember.isBlank imageLink
    "background-image: url('#{imageLink}');"


  click: ->
    @sendAction "action", @get("actionArg")
  
`export default MaterialTileComponent`
