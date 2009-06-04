dojo.provide('moviedb.ui._QueriedList');
dojo.require('dijit._Templated');
dojo.require('dijit.form.DropDownButton');
dojo.require('dijit.form.Form');
dojo.require('dijit.form.TextBox');
dojo.require('dijit.layout.BorderContainer');
dojo.require('dijit.layout.ContentPane');
dojo.require('dijit.TooltipDialog');
dojo.require('dojo.date.locale');
dojo.require('dojo.i18n');
dojo.require('dojox.form.BusyButton');
dojo.require('dojox.grid.DataGrid');
dojo.require('aiki.BusyForm');
dojo.require('aiki._QueriedListMixin');
dojo.requireLocalization('moviedb', 'common');


dojo.declare('moviedb.ui._QueriedList',
    [dijit.layout.BorderContainer, dijit._Templated, aiki._QueriedListMixin], {
  store: null,
  sortInfo: 1,
  rowsPerPage: 50,
  keepRows: 300,
  templatePath: dojo.moduleUrl('moviedb', 'ui/_QueriedList/QueriedList.html'),
  widgetsInTemplate: true,

  postMixInProperties: function() {
    this.inherited(arguments);
    this._loadNls();
  },

  postCreate: function() {
    this.inherited(arguments);

    var grid = this.gridNode;
    this._initGrid(grid, this);

    this._connectGridTopics(this._topic, grid);
    this._connectButtonTopics(this._topic, {
      'new':    this.newObjectNode,
      'delete': this.deleteObjectNode 
    });

    this._connectQuerying(grid, this.queryNode, this.queryFieldNode,
      this.allowedQueryAttributes, this.defaultQueryAttribute);

    this._makeQueryHelp(this.helpContentNode, 
      this.allowedQueryAttributes, this.defaultQueryAttribute);

    this._addTopAction('Show', dojo.hitch(this, function(context) {
      dojo.publish(this._topic + '.selected', [context[this._contextItemName]]);
    }));
    this._addTopAction('-');
    this._gridContextMenu(grid);
  },

  _loadNls: function() {
    this._nls = dojo.mixin({}, dojo.i18n.getLocalization('moviedb', 'common'));
    if (dojo.isArray(this._i18nBundles)) {
      dojo.forEach(this._i18nBundles, function(bundle) {
        dojo.mixin(this._nls, dojo.i18n.getLocalization('moviedb', bundle));
      }, this);
    }
  }
});
