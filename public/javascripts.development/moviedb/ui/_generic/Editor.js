dojo.provide('moviedb.ui._generic.Editor');
dojo.require('dijit._Widget');
dojo.require('aiki.Delegator');
dojo.require('aiki.api.Actions');
dojo.require('aiki.api.Edit');
dojo.require('moviedb.ui._generic.EditorController');

dojo.declare('moviedb.ui._generic.Editor',
  [dijit._Widget, dijit._Templated,
   aiki.Delegator('controller', aiki.api.Edit, aiki.api.Actions)], {

  store: null,
  object: null,

  getFeatures: function() {
    return {
      "aiki.api.View": true,
      "aiki.api.Edit": true,
      "aiki.api.Actions": true
	  };
  },

  postCreate: function() {
    this.controller = this._makeController();
    this.controller.relay(this);
  },

  _makeController: function() {
    return new moviedb.ui._generic.EditorController(this.store, this.object, this);
  },

  onCreated: function() {
  },
  onSaved: function() {
  },
  onError: function() {
  },
  onChange: function() {
  },
  onModified: function() {
  },
  onReverted: function() {
  }
});
