dojo.provide('moviedb.ui._AwardView.AwardingsList');
dojo.require('dijit._Widget');
dojo.require('dojox.dtl._DomTemplated');
dojo.require('dojox.dtl.contrib.data');
dojo.require('aiki.dtl.dom');

dojo.declare('moviedb.ui._AwardView.AwardingsList', [dijit._Widget, dojox.dtl._DomTemplated], {
  store: null,
  items: null,
  baseId: null,
  templatePath: dojo.moduleUrl("moviedb", "ui/_AwardView/AwardingsList.html")
});
