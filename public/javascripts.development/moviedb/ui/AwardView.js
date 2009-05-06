dojo.provide('moviedb.ui.AwardView');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('moviedb.ui._AwardView.Controller');
dojo.require('moviedb.ui._AwardView.View');
dojo.require('aiki.Delegator');

dojo.declare('moviedb.ui.AwardView',
  [dijit._Widget, dijit._Templated, moviedb.ui._AwardView.View,
   aiki.Delegator('controller', 'whenReady', 'getTitle', 'openTopGroup', 'showAwarding')], {

  _groupListWidget: 'moviedb.ui._AwardView.AwardingsList',

  showAwardName: false,
  yearGranularity: 10,

  store: null,
  object: null,

  getFeatures: function(){
    return {
      "aiki.api.View": true
    };
  },

  postMixInProperties: function() {
    this._groupListWidget = dojo.getObject(this._groupListWidget);
    this.inherited(arguments);
  },

  postCreate: function() {
    this.controller = this._makeController();
    this.inherited(arguments);
    this.controller.load();
  },

  _makeController: function() {
    return new moviedb.ui._AwardView.Controller(this.store, this.object, this);
  },

  _makeGroupListWidget: function(awardings, node) {
    return this.controller._makeGroupListWidget(this._groupListWidget, awardings, node);
  }
});
