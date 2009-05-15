dojo.provide('moviedb.ui.PersonItem');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');

dojo.declare('moviedb.ui.PersonItem', [dijit._Widget, dijit._Templated], {
  item: null,
  templatePath: dojo.moduleUrl('moviedb', 'ui/_PersonItem/PersonItem.html')
});
