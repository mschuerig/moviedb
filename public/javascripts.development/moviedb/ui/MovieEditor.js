dojo.provide('moviedb.ui.MovieEditor');
dojo.require('dojo.i18n');
dojo.require('dijit._Widget');
dojo.require('aiki.Delegator');
dojo.require('moviedb.ui._MovieEditor.Controller');
dojo.require('moviedb.ui._MovieEditor.View');

dojo.declare('moviedb.ui.MovieEditor',
  [dijit._Widget, dijit._Templated, moviedb.ui._MovieEditor.View,
   aiki.Delegator('controller', 'getTitle', 'isModified')], {

  store: null,
  object: null,

  getFeatures: function() {
    return {
      "aiki.api.View": true,
      "aiki.api.Edit": true
	};
  },

  postCreate: function() {
    this.controller = this._makeController();
    this.controller.relay(this);
  },

  _makeController: function() {
    return new moviedb.ui._MovieEditor.Controller(this.store, this.object, this);
  },

  onChange: function() {
    console.debug('*** MovieEditor onChange');
  },
  onModified: function() {
    console.debug('*** MovieEditor onModified');
  },
  onReverted: function() {
    console.debug('*** MovieEditor onReverted');
  }
});
