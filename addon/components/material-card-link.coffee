`import Ember from 'ember'`
`import layout from '../templates/components/material-card-link'`
`import CardCore from '../mixins/card-core'`

MaterialCardLinkComponent = Ember.LinkComponent.extend CardCore,
  layout: layout
  init: ->
    @_super arguments...
    @attrs.hasBlock = true
MaterialCardLinkComponent.reopenClass
  positionalParams: 'params'

`export default MaterialCardLinkComponent`
