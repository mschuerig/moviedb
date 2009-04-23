
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
dojo.require('dojox.grid.DataGrid');
dojo.require('dojox.json.query');
dojo.require('dojox.widget.PlaceholderMenuItem');
dojo.require('dojox.widget.Toaster');
dojo.require('moviedb.schema');
dojo.require('moviedb.AwardsTree');
dojo.require('moviedb.AwardView');
dojo.require('moviedb.EditorManager');
dojo.require('moviedb.Form');
dojo.require('moviedb.PersonEditor');
dojo.require('moviedb.Store');


dojo.setObject('moviedb.installTooltips', function(grid, showTooltip) {
  var hideTooltip = function(e) {
    dijit.hideTooltip(e.cellNode);
    dijit._masterTT._onDeck=null;
  };
  dojo.connect(grid, "onCellMouseOver", showTooltip);
  dojo.connect(grid, "onCellMouseOut", hideTooltip);
});

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
