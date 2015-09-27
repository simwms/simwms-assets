`import Ember from 'ember'`

ListController = Ember.Controller.extend
  guy: 
    id: "harold"
    name: "harold chen"
    title: "the honorable"
    job: "gambler"
    age: 44
    martialStatus: 
      primary: "single"
      secondary: "since 1995"

  keys: Ember.A ["name", "title", "job", "age", "martialStatus", "nonfield"]
  icons:
    name: "fa fa-user fa-lg"
    title: "fa fa-institution fa-lg"
    job: "fa fa-gear fa-lg"
    age: "fa fa-birthday-cake fa-lg"
    martialStatus: "fa fa-heart-o fa-lg"

`export default ListController`