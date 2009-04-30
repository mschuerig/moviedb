dojo.provide('moviedb.MoviesGrid');
dojo.require('dijit._Templated');
dojo.require('dijit.form.Form');
dojo.require('dijit.form.TextBox');
dojo.require('dijit.layout.BorderContainer');
dojo.require('dijit.layout.ContentPane');
dojo.require('dijit.Tooltip');
//dojo.require('dojo.i18n');
dojo.require('dojox.form.BusyButton');
dojo.require('dojox.grid.DataGrid');
dojo.require('aiki.Form');
dojo.require('aiki._QueriedListMixin');

dojo.declare('moviedb.MoviesGrid',
    [dijit.layout.BorderContainer, dijit._Templated, aiki._QueriedListMixin], {
  store: null,
  sortInfo: -2,
  rowsPerPage: 50,
  keepRows: 300,
  templatePath: dojo.moduleUrl('moviedb', 'templates/MoviesGrid.html'),
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

  postCreate: function() {
    this.inherited(arguments);

    var grid = this.gridNode;
    this._initGrid(grid, this);

    this._connectEvents(grid, this.newMovieNode, 'movie');

    this._connectQuerying(grid, this.queryNode, this.queryFieldNode,
      this.allowedQueryAttributes, this.defaultQueryAttribute);

    dojo.connect(grid, 'onCellContextMenu', dojo.hitch(this, '_gridCellContextMenu'));
  },

  _gridCellContextMenu: function(e) {
    if (e.cell.field == "awardings") {
      var movie = e.grid.getItem(e.rowIndex);
      var awardings = this.store.getValue(movie, 'awardings');
      if (awardings) {
        var awardingsMenu = new dijit.Menu({targetNodeIds: e.cellNode});

        var self = this;
        dojo.forEach(awardings, function(awarding) {
          awardingsMenu.addChild(new dijit.MenuItem({
            label: self.store.getValue(awarding, 'title'),
            onClick: dojo.hitch(self, '_awardingSelected', awarding)
          }));
        });

        awardingsMenu.startup();
        dojo.connect(awardingsMenu, 'onClose', function() {
          awardingsMenu.uninitialize();
        });
        awardingsMenu._openMyself(e);
      }
    }
  },

  _awardingSelected: function(awarding) {
    var hints = {
      context: 'awardGroup'
    };
    dojo.publish('awarding.selected', [awarding, hints]);
  }
});
