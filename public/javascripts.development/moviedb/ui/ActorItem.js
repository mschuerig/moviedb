dojo.provide('moviedb.ui.ActorItem');
dojo.require('dijit.InlineEditBox');
dojo.require('moviedb.ui.PersonItem');

dojo.declare('moviedb.ui.ActorItem', moviedb.ui.PersonItem, {
  templatePath: dojo.moduleUrl('moviedb', 'ui/_ActorItem/ActorItem.html'),
  widgetsInTemplate: true
});
