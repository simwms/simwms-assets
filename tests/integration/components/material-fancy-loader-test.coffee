`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'material-fancy-loader', 'Integration | Component | material fancy loader', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{material-fancy-loader}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#material-fancy-loader}}
      template block text
    {{/material-fancy-loader}}
  """

  assert.equal @$().text().trim(), 'template block text'
