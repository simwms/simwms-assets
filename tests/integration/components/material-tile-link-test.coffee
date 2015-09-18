`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'material-tile-link', 'Integration | Component | material tile link', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{material-tile-link}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#material-tile-link}}
      template block text
    {{/material-tile-link}}
  """

  assert.equal @$().text().trim(), 'template block text'
