`import Ember from 'ember'`
`import layout from '../templates/components/material-power-card'`

{computed} = Ember
{alias} = computed

MaterialPowerCardComponent = Ember.Component.extend
  layout: layout
  classNames: ["col", "material-power-card-container"]
  classNameBindings: ["cardQuartet"]
  isQuartet: alias "parentView.isQuartet"
  style: computed "image",
    get: ->
      return unless ( image = @get "image" )?
      "background-image: url('#{image}');"
  cardQuartet: computed "isQuartet",
    get: ->
      return "s12 m6 l6" if @get("isQuartet")

  powerCardClass: computed "isQuartet",
    get: ->
      return "material-card-quartet" if @get("isQuartet")


`export default MaterialPowerCardComponent`
