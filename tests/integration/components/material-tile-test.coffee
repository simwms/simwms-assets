`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'material-tile', 'Integration | Component | material tile', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{material-tile}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#material-tile}}
      template block text
    {{/material-tile}}
  """

  assert.equal @$().text().trim(), 'template block text'
