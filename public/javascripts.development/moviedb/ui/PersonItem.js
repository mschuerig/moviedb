dojo.provide('moviedb.ui.PersonItem');
dojo.require('dijit._Widget');
dojo.require('aiki._DataTemplated');

dojo.declare('moviedb.ui.PersonItem', [dijit._Widget, aiki._DataTemplated], {
  item: null,
  store: null,
  templatePath: dojo.moduleUrl('moviedb', 'ui/_PersonItem/PersonItem.html')
});
