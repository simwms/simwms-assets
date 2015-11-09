`import Ember from 'ember'`
`import layout from '../templates/components/material-accordion-collection'`

MaterialAccordionCollectionComponent = Ember.Component.extend
  tagName: "ul"
  layout: layout
  classNames: ["collapsible"]
  attributeBindings: ["data-collapsible"]
  "data-collapsible": "accordion"

  didInsertElement: ->
    @$()?.collapsible()

`export default MaterialAccordionCollectionComponent`
