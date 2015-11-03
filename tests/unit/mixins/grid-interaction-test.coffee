`import Ember from 'ember'`
`import GridInteractionMixin from '../../../mixins/grid-interaction'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | grid interaction'

# Replace this with your real tests.
test 'it works', (assert) ->
  GridInteractionObject = Ember.Object.extend GridInteractionMixin
  subject = GridInteractionObject.create()
  assert.ok subject
