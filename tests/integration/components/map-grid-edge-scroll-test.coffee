`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'map-grid-edge-scroll', 'Integration | Component | map grid edge scroll', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{map-grid-edge-scroll}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#map-grid-edge-scroll}}
      template block text
    {{/map-grid-edge-scroll}}
  """

  assert.equal @$().text().trim(), 'template block text'
