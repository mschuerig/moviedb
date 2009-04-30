dojo.provide('aiki.QueryHelp');
dojo.require('dojo.i18n');
dojo.require('dijit._Widget');
dojo.require('dojox.dtl._Templated');

dojo.declare('aiki.QueryHelp', [dijit._Widget, dojox.dtl._Templated], {
  attributes: [],
  defaultAttribute: '',
  templatePath: dojo.moduleUrl("aiki", "templates/QueryHelp.html")
});
