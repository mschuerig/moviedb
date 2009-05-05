dojo.provide('moviedb.ui.AwardView');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('moviedb.ui._AwardView.Controller');
dojo.require('moviedb.ui._AwardView.View');
dojo.require('moviedb.ui._AwardView.GroupManager');
dojo.require('aiki.Delegator');

dojo.declare('moviedb.ui.AwardView',
  [dijit._Widget, dijit._Templated, moviedb.ui._AwardView.View,
   aiki.Delegator('controller', 'getFeatures', 'getTitle', 'openTopGroup', 'showAwarding')], {

  showAwardName: false,
  yearGranularity: 10,

  store: null,
  object: null,

  postCreate: function() {
    this.controller = this._buildController(this);
    var whenLoaded = this.controller.load();
    whenLoaded.addCallback(this, '_renderView');
  },

  _buildController: function(view) {
    this.controller = new moviedb.ui._AwardView.Controller(this.store, this.object, view);

    return this.controller;
  }
});
