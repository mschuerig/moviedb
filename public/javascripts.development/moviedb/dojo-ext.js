dojo.provide('moviedb.dojo-ext');
dojo.require('plugd.ancestor');

dojo.find = function(/*Array|String*/arr, /*Function|String*/callback, /*Object?*/thisObject) {
  return dojo.filter(arr, callback, thisObject)[0];
};

dojo.groupBy = function(/*Array*/items, /*Function*/extractor) {
  var keys = [];
  var groups = {};
  for (var i = 0, l = items.length; i < l; i++) {
    var item = items[i];
    var key = extractor(item);
    var group = groups[key];
    if (!group) {
      keys.push(key);
      group = groups[key] = [];
    }
    group.push(item);
  }
  return { keys: keys, groups: groups };
};

