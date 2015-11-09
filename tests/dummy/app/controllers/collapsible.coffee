`import Ember from 'ember'`

{Controller, computed: {alias, equal}} = Ember

CollapsibleController = Controller.extend
  queryParams: ['e']

`export default CollapsibleController`