`import Ember from 'ember'`
`import GridElementMixin from '../../../mixins/grid-element'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | grid element'

# Replace this with your real tests.
test 'it works', (assert) ->
  GridElementObject = Ember.Object.extend GridElementMixin
  subject = GridElementObject.create()
  assert.ok subject
