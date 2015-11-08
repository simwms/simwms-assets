`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'map-grid-ghost-box', 'Integration | Component | map grid ghost box', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{map-grid-ghost-box}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#map-grid-ghost-box}}
      template block text
    {{/map-grid-ghost-box}}
  """

  assert.equal @$().text().trim(), 'template block text'
