`import Ember from 'ember'`
`import layout from '../templates/components/material-cards-collection'`

MaterialCardsCollectionComponent = Ember.Component.extend
  layout: layout
  classNames: ["material-cards-collection", "row"]
  cards: Ember.A()
  isQuartet: Ember.computed.equal "cards.length", 4

`export default MaterialCardsCollectionComponent`
