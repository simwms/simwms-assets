`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'map-grid', 'Integration | Component | map grid', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{map-grid}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#map-grid}}
      template block text
    {{/map-grid}}
  """

  assert.equal @$().text().trim(), 'template block text'
