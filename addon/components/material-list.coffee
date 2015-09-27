`import Ember from 'ember'`
`import layout from '../templates/components/material-list'`

computed = Ember.computed

ListItem = Ember.Object.extend
  hasIcon: computed.or "icon"
  iconClass: computed.alias "icon"
  isPresent: computed.and "primary"
  value: computed
    set: (key, value) ->
      switch typeof value
        when "object"
          @set "primary", Ember.get(value, "primary")
          @set "secondary", Ember.get(value, "secondary")
        else @set "primary", value


MaterialListComponent = Ember.Component.extend
  layout: layout
  classNames: ["material-list"]
  tagName: "ul"
  skipBlank: true
  displayKeys: Ember.A()
  iconMap: Ember.Object.create()

  listItems: computed.filter "rawListItems", (li) ->
    return true unless @get "skipBlank"
    Ember.isPresent li.get("primary")

  rawListItems: computed "model", "iconMap", "displayKeys.[]", ->
    model = @get "model"
    iconMap = @get "iconMap"
    Ember.A @get("displayKeys").map (key) =>
      ListItem.create
        value: Ember.get model, key
        icon: Ember.get iconMap, key

`export default MaterialListComponent`
