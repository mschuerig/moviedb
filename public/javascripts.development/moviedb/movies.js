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
dojo.require('aiki.EditorManager');
dojo.require('aiki.Form');
dojo.require('aiki.Store');
dojo.require('moviedb.schema');
dojo.require('moviedb.AwardsTree');
dojo.require('moviedb.AwardView');
dojo.require('moviedb.MoviesGrid');
dojo.require('moviedb.PeopleGrid');
dojo.require('moviedb.PersonEditor');

dojo.setObject('moviedb.installTooltips', function(grid, showTooltip) {
  var hideTooltip = function(e) {
    dijit.hideTooltip(e.cellNode);
    dijit._masterTT._onDeck=null;
  };
  dojo.connect(grid, "onCellMouseOver", showTooltip);
  dojo.connect(grid, "onCellMouseOut", hideTooltip);
});

