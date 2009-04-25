dojo.provide('moviedb.dojo-ext');
dojo.require('plugd.ancestor');

dojo.find = function(/*Array|String*/arr, /*Function|String*/callback, /*Object?*/thisObject) {
  var pred = dojo.hitch(thisObject, callback);
  var result;
  var found = dojo.some(arr, function(v){
    if(pred(v)) {
      result = v;
      return true;
    }
    return false;
  });
  return result;
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

