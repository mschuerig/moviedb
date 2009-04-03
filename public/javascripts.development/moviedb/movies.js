
(function() {
  dojo.provide('moviedb.movies');

  dojo.require('dijit.Menu');
  dojo.require('dijit.MenuItem');
  dojo.require('dijit.MenuSeparator');
  dojo.require('dijit.Tooltip');
  dojo.require('dijit.Tree');
  dojo.require('dijit.form.DateTextBox');
  dojo.require('dijit.form.Form');
  dojo.require('dijit.form.Textarea');
  dojo.require('dijit.form.ValidationTextBox');
  dojo.require('dijit.layout.BorderContainer');
  dojo.require('dijit.layout.BorderContainer');
  dojo.require('dijit.layout.ContentPane');
  dojo.require('dijit.layout.ContentPane');
  dojo.require('dijit.layout.TabContainer');
  dojo.require('dijit.tree.ForestStoreModel');
  dojo.require('dojo.back');
  dojo.require('dojo.data.ItemFileReadStore');
  dojo.require('dojo.parser');
  dojo.require('dojox.data.ClientFilter');
  dojo.require('dojox.data.JsonQueryRestStore');
  dojo.require('dojox.grid.DataGrid');
  dojo.require('dojox.json.query');
  dojo.require('dojox.widget.PlaceholderMenuItem');
  dojo.require('dojox.widget.Toaster');
  dojo.require('moviedb.Form');

  dojo.declare('moviedb.Movie', null, {
    constructor: function(data) {
      console.log('** CTOR: ', arguments); //### REMOVE
    },
    displayTitle: function() {
      return this.title + ' (' + this.releaseYear + ')';
    }
  });

  dojo.declare("moviedb.Store", dojox.data.JsonRestStore, { //### TODO JsonQueryRestStore
    _processResults: function(results, deferred) {
      return results;
    },
    fetch: function(args) {
      console.log("*** fetch: ", args);
      var query = args.query;
        if (query && dojo.isObject(query)) {
          args.queryStr = '?' + this._matchingClause(query) + this._sortingClause(args.sort);
        }
      return this.inherited(arguments);
    },
    _matchingClause: function(query) {
      console.log("***fetch, query: ", query);
      return ''; //### TODO build filter condition
    },
    _sortingClause: function(sort) {
      console.log("***fetch, sort: ", sort);
      if (!dojo.isArray(sort) || sort.length === 0) return '';
      return '[' + dojo.map(sort, function(attr) {
        if (dojo.isObject(attr)) {
          return (attr.descending ? '\\' : '/') + attr.attribute;
        } else {
          return '/' + attr;
        }
      }).join(',') + ']';
    }
  });

  var installTooltips = function(grid, showTooltip) {
    var hideTooltip = function(e) {
	  dijit.hideTooltip(e.cellNode);
	  dijit._masterTT._onDeck=null;
    };
    dojo.connect(grid, "onCellMouseOver", showTooltip);
    dojo.connect(grid, "onCellMouseOut", hideTooltip);
  };

  dojo.setObject('moviedb.installTooltips', installTooltips);

})();
