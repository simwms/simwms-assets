`import Ember from 'ember'`

{computed} = Ember
{alias} = computed

CardCore = Ember.Mixin.create
  classNames: ["col", "material-power-card-container"]
  classNameBindings: ["cardStyle"]
  isQuartet: alias "parentView.isQuartet"
  isQuadforce: alias "parentView.isQuadforce"
  isTriplet: alias "parentView.isTriplet"
  isTriforce: alias "parentView.isTriforce"
  style: computed "image",
    get: ->
      return unless ( image = @get "image" )?
      "background-image: url('#{image}');"

  cardStyle: computed "isQuartet", "isQuadforce", "isTriplet", "isTriforce",
    get: ->
      return "quadforce s12 m6 l6" if @get("isQuadforce")
      return "s12 m6 l6" if @get("isQuartet")
      return "triforce s12 m12 l6" if @get("isTriforce")
      return "s12 m4 l4" if @get("isTriplet")

  powerCardClass: computed "isQuartet", "isQuadforce", "isTriplet", "isTriforce",
    get: ->
      return "material-card-quadforce" if @get("isQuadforce")
      return "material-card-quartet" if @get("isQuartet")
      return "material-card-triforce" if @get("isTriforce")
      return "material-card-triplet" if @get("isTriplet")

`export default CardCore`