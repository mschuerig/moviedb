dojo.provide('moviedb.Store');
dojo.require('dojox.data.JsonRestStore');

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
