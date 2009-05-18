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
  objectClass: null,

  getFeatures: function() {
    return {
      "aiki.api.View": true,
      "aiki.api.Edit": true,
      "aiki.api.Actions": true
	  };
  },

  _setObjectAttr: function(object) {
    this.object = object ? object : this._createNewObject();
  },

  _setObjectClassAttr: function(objectClass) {
    this.objectClass = objectClass; 
    this._setObjectAttr(this.object);
  },

  postCreate: function() {
    this.controller = this._makeController();
    this.controller.relay(this);
    this.controller.populate();
  },

  _makeController: function() {
    return new moviedb.ui._generic.EditorController(this.store, this.object, this);
  },
  
  _createNewObject: function() {
    return this.objectClass ? new this.objectClass() : {};
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
