dojo.provide('aiki.Store');
dojo.require('dojox.data.JsonRestStore');

dojo.declare("aiki.Store", dojox.data.JsonRestStore, {
 _processResults: function(results, deferred) {
/* ### REMOVE
    dojo.forEach(results.items, function(item) {
      if (!item.awards) {
        item.awards = [];
      }
    });
*/
    return results;
  },
  fetch: function(args) {
    console.log("*** fetch: ", args); //### REMOVE
    var query = args.query;
    var sort  = args.sort;
    if (query && dojo.isObject(query) || sort && dojo.isObject(sort)) {
      args.queryStr = '?' + this._matchingClause(query) + this._sortingClause(sort);
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
