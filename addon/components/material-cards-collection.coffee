`import Ember from 'ember'`
`import layout from '../templates/components/material-cards-collection'`

{computed} = Ember
{equal} = computed

MaterialCardsCollectionComponent = Ember.Component.extend
  layout: layout
  classNames: ["material-cards-collection", "row"]
  cards: Ember.A()
  isQuartet: equal "cards.length", 4
  isTriplet: equal "cards.length", 3
  isTriforce: computed.and "isTriplet", "styleTriforce"
  isQuadforce: computed.and "isQuartet", "styleQuadforce"
  styleTriforce: equal "style", "triforce"
  styleQuadforce: equal "style", "quadforce"

`export default MaterialCardsCollectionComponent`
