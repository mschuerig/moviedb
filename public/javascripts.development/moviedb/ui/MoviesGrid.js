dojo.provide('moviedb.ui.MoviesGrid');
dojo.require('dijit._Templated');
dojo.require('dijit.form.Form');
dojo.require('dijit.form.TextBox');
dojo.require('dijit.layout.BorderContainer');
dojo.require('dijit.layout.ContentPane');
dojo.require('dojo.i18n');
dojo.require('dojox.form.BusyButton');
dojo.require('dojox.grid.DataGrid');
dojo.require('aiki.Action');
dojo.require('aiki.BusyForm');
dojo.require('aiki._QueriedListMixin');

dojo.declare('moviedb.ui.MoviesGrid',
    [dijit.layout.BorderContainer, dijit._Templated, aiki._QueriedListMixin], {
  store: null,
  sortInfo: -2,
  rowsPerPage: 50,
  keepRows: 300,
  templatePath: dojo.moduleUrl('moviedb', 'ui/_MoviesGrid/MoviesGrid.html'),
  widgetsInTemplate: true,
/*
  _awardingsFormatter: function(awardings) {
    return awardings ? dojo.string.rep('*', awardings.length) : '';
  },
  _yearFormatter: function(date) {
    return date ? 1900 + date.getYear() : '';
  },
*/
  gridStructure: [
    { field: "title",       name: "Title",  width: "auto" },
    { field: "releaseDate", name: "Year",   width: "5em",
      formatter: function(date) { return date ? 1900 + date.getYear() : ''; } },
    { field: "awardings",      name: "Awards", width: "6em",
      formatter: function(awardings) { return awardings ? dojo.string.rep('*', awardings.length) : ''; } }
  ],

  allowedQueryAttributes: ['title', 'year', 'awards'],
  defaultQueryAttribute: 'title',

  _contextItemName: 'movie',

  postCreate: function() {
    this.inherited(arguments);

    var grid = this.gridNode;
    this._initGrid(grid, this);

    this._connectGridTopics('movie', grid);
    this._connectButtonTopics('movie', {
      'new':    this.newMovieNode,
      'delete': this.deleteMovieNode 
    });

    this._connectQuerying(grid, this.queryNode, this.queryFieldNode,
    this.allowedQueryAttributes, this.defaultQueryAttribute);

    this._addTopAction('Show Movie', function(context) { //### i18n
      dojo.publish('movie.selected', [context.movie]);
    });
    this._addTopAction('-');
    this._gridContextMenu(grid);
  },

  _awardingSelected: function(awarding) {
    var hints = {
      context: 'awardGroup'
    };
    dojo.publish('awarding.selected', [awarding, hints]);
  },

  _getActions: function(context, event) {
    var actions = this.inherited(arguments);
    
    if (event.cell.field == 'awardings') {
      var awardings = this.store.getValue(context.movie, 'awardings');
      if (awardings && awardings.length > 0) {
        actions.push('Awards'); //### i18n
        for (var i = 0; i < awardings.length; i++) {
          var awarding = awardings[i];
          actions.push(new aiki.Action(
            this.store.getValue(awarding, 'title'),
            dojo.hitch(this, '_awardingSelected', awarding)
          ));
        }
      }
    }
    return actions;
  }
});
