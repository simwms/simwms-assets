`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'material-object-listify', 'Integration | Component | material object listify', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{material-object-listify}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#material-object-listify}}
      template block text
    {{/material-object-listify}}
  """

  assert.equal @$().text().trim(), 'template block text'
