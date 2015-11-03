`import Ember from 'ember'`

{Controller, computed: {alias}} = Ember

GridController = Controller.extend
  road: alias "model.road"
  house: alias "model.house"

`export default GridController`