`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'material-tiles-collection', 'Integration | Component | material tiles collection', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{material-tiles-collection}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#material-tiles-collection}}
      template block text
    {{/material-tiles-collection}}
  """

  assert.equal @$().text().trim(), 'template block text'
