`import Ember from 'ember'`
`import layout from '../templates/components/material-accordion'`

{computed, LinkComponent} = Ember
{alias} = computed
access = (index) ->
  computed "params.[]",
    get: ->
      @getWithDefault("params", [])[index]

MaterialAccordionComponent = LinkComponent.extend
  layout: layout
  tagName: "li"
  init: ->
    @_super arguments...
    @attrs.hasBlock = true
  paramRoute: access 0
  paramModel: access 1
  paramOpts: access 2
  paramCount: alias "params.length"
  faIcon: computed "icon",
    get: ->
      icon = @getWithDefault("icon", "")
      return icon if icon.match /^fa/
  mdIcon: computed "icon",
    get: ->
      icon = @getWithDefault("icon", "")
      return icon if icon.match /^mdi/

MaterialAccordionComponent.reopenClass
  positionalParams: 'params'

`export default MaterialAccordionComponent`
