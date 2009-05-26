dojo.provide('moviedb.ui.DirectorItem');
dojo.require('dijit.InlineEditBox');
dojo.require('moviedb.ui.PersonItem');

dojo.declare('moviedb.ui.DirectorItem', moviedb.ui.PersonItem, {
  templatePath: dojo.moduleUrl('moviedb', 'ui/_DirectorItem/DirectorItem.html'),
  widgetsInTemplate: true
});
