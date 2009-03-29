
(function() {
  dojo.provide("moviedb.movies");

  dojo.require("dijit.layout.BorderContainer");
  dojo.require("dijit.layout.ContentPane");
  dojo.require("dojox.data.ClientFilter");
  dojo.require("dojox.data.JsonQueryRestStore");
  dojo.require("dojox.grid.DataGrid");
  dojo.require("dojox.json.query");
  dojo.require("dojox.widget.PlaceholderMenuItem");
  dojo.require('dijit.Tooltip');
  dojo.require('dijit.Tree');
  dojo.require('dijit.layout.BorderContainer');
  dojo.require('dijit.layout.ContentPane');
  dojo.require('dijit.tree.ForestStoreModel');
  dojo.require('dojo.data.ItemFileReadStore');

  dojo.declare("moviedb.Store", dojox.data.JsonRestStore, {
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

})();
