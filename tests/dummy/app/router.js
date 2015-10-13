import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.resource("tiles", {path: "/tiles"}, function(){
    this.resource("tiles.tile", {path: "t/:id"}, function(){});
  });
  this.route("loader");
  this.route("list");
  this.resource("cards", {path: "/cards"}, function(){
    this.route("quartet");
    this.route("quadforce");
    this.route("triplet");
    this.route("triforce");
  });
});

export default Router;
