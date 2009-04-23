
dojo.provide('moviedb.movies');

dojo.require('dijit.Declaration');
dojo.require('dijit.Menu');
dojo.require('dijit.MenuItem');
dojo.require('dijit.MenuSeparator');
dojo.require('dijit.TitlePane');
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
dojo.require('dojo.parser');
dojo.require('dojox.data.JsonRestStore');
dojo.require('dojox.form.BusyButton');
dojo.require('dojox.grid.DataGrid');
dojo.require('dojox.json.query');
dojo.require('dojox.widget.PlaceholderMenuItem');
dojo.require('dojox.widget.Toaster');
dojo.require('moviedb.schema');
dojo.require('moviedb.AwardView');
dojo.require('moviedb.EditorManager');
dojo.require('moviedb.Form');
dojo.require('moviedb.PersonEditor');

dojo.declare("moviedb.Store", dojox.data.JsonRestStore, {
  _processResults: function(results, deferred) {
    dojo.forEach(results.items, function(item) {
      if (!item.awards) {
        item.awards = [];
      }
    });
    return results;
  },
  fetch: function(args) {
    console.log("*** fetch: ", args); //### REMOVE
    var query = args.query;
    if (query && dojo.isObject(query)) {
      args.queryStr = '?' + this._matchingClause(query) + this._sortingClause(args.sort);
    }
    //### TODO add onError unless already defined
    return this.inherited(arguments);
  },
  _matchingClause: function(query) {
    console.log("***fetch, query: ", query); //### REMOVE
    var queryStr = '';
    for (var q in query) {
      var value = query[q];
      if (value != '*') {
        queryStr += '[?' + q + "='" + value + "']";
      }
    }
    return queryStr;
  },
  _sortingClause: function(sort) {
    console.log("***fetch, sort: ", sort); //### REMOVE
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

dojo.setObject('moviedb.installTooltips', function(grid, showTooltip) {
  var hideTooltip = function(e) {
    dijit.hideTooltip(e.cellNode);
    dijit._masterTT._onDeck=null;
  };
  dojo.connect(grid, "onCellMouseOver", showTooltip);
  dojo.connect(grid, "onCellMouseOut", hideTooltip);
});
