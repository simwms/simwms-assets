`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'map-grid-ghost-batch', 'Integration | Component | map grid ghost batch', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{map-grid-ghost-batch}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#map-grid-ghost-batch}}
      template block text
    {{/map-grid-ghost-batch}}
  """

  assert.equal @$().text().trim(), 'template block text'
