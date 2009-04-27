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
  _awardsFormatter: function(awards) {
    return awards ? dojo.string.rep('*', awards.length) : '';
  },
  _yearFormatter: function(date) {
    return date ? 1900 + date.getYear() : '';
  },
*/
  _gridStructure: [
    { field: "title",       name: "Title",  width: "auto" },
    { field: "releaseDate", name: "Year",   width: "5em",
      formatter: function(date) { return date ? 1900 + date.getYear() : ''; } },
    { field: "awards",      name: "Awards", width: "15%",
      formatter: function(awards) { return awards ? dojo.string.rep('*', awards.length) : ''; } }
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

    dojo.connect(grid, 'onCellContextMenu', this._gridCellContextMenu);
  },

  _gridCellContextMenu: function(e) {
    if (e.cell.field == "awards") {
      var movie = e.grid.getItem(e.rowIndex);
      if (movie.awards) {
        var awards = movie.awards;
        var awardsMenu = new dijit.Menu({targetNodeIds: e.cellNode});

        dojo.forEach(awards, function(awarding) {
          awardsMenu.addChild(new dijit.MenuItem({
            label: awarding.title,
            onClick: function() { dojo.publish('awarding.selected', [awarding]); }
          }));
        });

        awardsMenu.startup();
        dojo.connect(awardsMenu, 'onClose', function() {
          awardsMenu.uninitialize();
        });
        awardsMenu._openMyself(e);
      }
    }
  }
});
