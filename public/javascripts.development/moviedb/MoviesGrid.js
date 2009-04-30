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
dojo.require('aiki.QueryParser');
dojo.require('aiki.QueryTooltip');

dojo.declare('moviedb.MoviesGrid', [dijit.layout.BorderContainer, dijit._Templated], {
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
  _gridStructure: [
    { field: "title",       name: "Title",  width: "auto" },
    { field: "releaseDate", name: "Year",   width: "5em",
      formatter: function(date) { return date ? 1900 + date.getYear() : ''; } },
    { field: "awardings",      name: "Awards", width: "6em",
      formatter: function(awardings) { return awardings ? dojo.string.rep('*', awardings.length) : ''; } }
  ],

  postCreate: function() {
    this.inherited(arguments);

    this._queryParser = new aiki.QueryParser(['title', 'year', 'awards'], 'title');
    new aiki.QueryTooltip({
      queryParser: this._queryParser,
      connectId: [this.queryFieldNode.domNode]
    });

    var grid = this.gridNode;

    grid.attr('structure', this._gridStructure);
    grid.setSortInfo(this.sortInfo);
    grid.setQuery(this.query);
    grid.attr('keepRows', this.keepRows);
    grid.setStore(this.store);

    dojo.connect(this.queryNode, 'onSubmit', dojo.hitch(this, function(event) {
      dojo.stopEvent(event);
      var queryStr = this.queryFieldNode.attr('value');
      grid.setQuery(this._queryParser.parse(queryStr));
    }));

    dojo.connect(this.newMovieNode, 'onSubmit', dojo.hitch(this, function(event) {
      dojo.stopEvent(event);
      dojo.publish('movie.new');
    }));

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
    var hints = {
      context: 'awardGroup'
    };
    dojo.publish('awarding.selected', [awarding, hints]);
  }
});
