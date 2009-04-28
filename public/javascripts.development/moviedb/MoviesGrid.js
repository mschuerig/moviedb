dojo.provide('moviedb.MoviesGrid');
dojo.require('dijit._Templated');
dojo.require('dijit.form.Form');
dojo.require('dijit.form.TextBox');
dojo.require('dijit.layout.BorderContainer');
dojo.require('dijit.layout.ContentPane');
//dojo.require('dojo.i18n');
dojo.require('dojox.form.BusyButton');
dojo.require('dojox.grid.DataGrid');
dojo.require('aiki.Form');

dojo.declare('moviedb.MoviesGrid', [dijit.layout.BorderContainer, dijit._Templated], {
  store: null,
  sortInfo: -2,
  rowsPerPage: 50,
  keepRows: 300,
  baseClass: 'moviedbMoviesGrid',
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
  _gridStructure: [
    { field: "title",       name: "Title",  width: "auto" },
    { field: "releaseDate", name: "Year",   width: "5em",
      formatter: function(date) { return date ? 1900 + date.getYear() : ''; } },
    { field: "awardings",      name: "Awards", width: "15%",
      formatter: function(awardings) { return awardings ? dojo.string.rep('*', awardings.length) : ''; } }
  ],

  postCreate: function() {
    this.inherited(arguments);

    var grid = this.gridNode;

    grid.attr('structure', this._gridStructure);
    grid.setSortInfo(this.sortInfo);
    grid.setQuery(this.query);
    grid.attr('keepRows', this.keepRows);
    grid.setStore(this.store);

    dojo.connect(grid, 'onRowDblClick', function(event) {
      dojo.publish('movie.selected', [grid.getItem(event.rowIndex)]);
    });

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
    dojo.publish('awarding.selected', [awarding]);
  }
});
