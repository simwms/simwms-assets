`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'map-grid-polyline', 'Integration | Component | map grid polyline', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{map-grid-polyline}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#map-grid-polyline}}
      template block text
    {{/map-grid-polyline}}
  """

  assert.equal @$().text().trim(), 'template block text'
