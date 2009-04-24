dojo.provide('moviedb.MoviesGrid');

    function buildMoviesGrid(store, domNode) {
      var awardsFormatter = function(awards) {
        return awards ? dojo.string.rep('*', awards.length) : '';
      };
      var yearFormatter = function(date) {
        return date ? 1900 + date.getYear() : '';
      };

      var grid = new dojox.grid.DataGrid({
        query: { title: '*' },
        sortInfo: -2,
        store: store,
        structure: [
          { field: "title", name: "Title", width: "auto" },
          { field: "releaseDate", name: "Year", width: "5em", formatter: yearFormatter },
          { field: "awards", name: "Awards", width: "15%", formatter: awardsFormatter }
        ],
        selectionMode: 'single',
        rowsPerPage: 50,
        keepRows: 300
      }, domNode);

      grid.onCellContextMenu = function(e) {
        if (e.cell.field == "awards") {
          var movie = e.grid.getItem(e.rowIndex);
          if (movie.awards) {
            var awards = movie.awards;
            var awardsMenu = new dijit.Menu({targetNodeIds: e.cellNode});
//            awardsMenu.addChild(new dijit.MenuItem({
//              label: 'Overview'//,
//              onClick: function() { dojo.publish('award.selected', [awards]) }
//            }));
//            awardsMenu.addChild(new dijit.MenuSeparator());
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
	  };
	  grid.onHeaderContextMenu = function(e) {
	    console.log('*** onHeaderContextMenu: ', e); //### REMOVE
	  };

      dojo.connect(grid, 'onRowDblClick', function(event) {
        dojo.publish('movie.selected', [grid.getItem(event.rowIndex)]);
      });

      return grid;
    }
