`import Ember from 'ember'`
`import layout from '../templates/components/material-tile-secondary'`

MaterialTileSecondaryComponent = Ember.Component.extend
  layout: layout
  classNames: ["material-tile-secondary"]
  icon: "fa fa-star"
  actions:
    secondaryInteraction: ->
      @sendAction()

`export default MaterialTileSecondaryComponent`
