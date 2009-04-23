dojo.provide('moviedb.dojo-ext');

dojo.find = function(/*Array|String*/arr, /*Function|String*/callback, /*Object?*/thisObject) {
  return dojo.filter(arr, callback, thisObject)[0];
};

dojo.try = function(/*Object*/obj, /*Function|String*/func, /*Array?*/args, /*Object?*/defaultValue) {
  if (dojo.isFunction(obj[func])) {
    return obj[func].apply(obj, args || []);
  } else {
    return defaultValue;
  }
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

dojo.ancestor = function(/*String|DOMNode*/startNode, /*String*/query, /*String|DOMNode?*/root) {
  var node = dojo.byId(startNode);
  var candidates = dojo.query(query, root);
  root = root ? root : dojo.doc;
  while (node && node !== root) {
    if (candidates.indexOf(node) >= 0) {
      return node;
    }
    node = node.parentNode;
  }
  return null;
};
