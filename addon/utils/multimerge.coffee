`import Ember from 'ember'`

{isBlank, isEmpty, merge, A} = Ember

multimerge = (object, objects...) ->
  return object if isBlank(objects) or isEmpty(objects)
  A objects
  .reduce merge, object

`export default multimerge`
