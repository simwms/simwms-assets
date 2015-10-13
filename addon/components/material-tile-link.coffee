`import Ember from 'ember'`
`import layout from '../templates/components/material-tile'`

MaterialTileLinkComponent = Ember.LinkComponent.extend
  layout: layout
  classNames: ["col", "s6", "m4", "l3", "material-tile", "waves-light", "waves-effect"]
  classNameBindings: ["active:z-depth-3:"]
  attributeBindings: ["style"]
  style: Ember.computed "background", ->
    imageLink = @get("background")
    return if Ember.isBlank imageLink
    "background-image: url('#{imageLink}');"

MaterialTileLinkComponent.reopenClass
  positionalParams: 'params'

`export default MaterialTileLinkComponent`
