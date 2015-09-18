import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.resource("tiles", {path: "/tiles"}, function(){
    this.resource("tiles.tile", {path: "t/:id"}, function(){});
  });
});

export default Router;
