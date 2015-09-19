`import Ember from 'ember'`

LoaderController = Ember.Controller.extend
  isBusy: false
  actions:
    submit: ->
      @set "isBusy", true
      # window.setTimeout (=> @set "isBusy", false), 7000



`export default LoaderController`