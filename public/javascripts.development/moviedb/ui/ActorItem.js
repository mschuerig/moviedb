dojo.provide('moviedb.ui.ActorItem');
dojo.require('dijit.InlineEditBox');
dojo.require('dijit.form.Button');
dojo.require('moviedb.ui.PersonItem');
dojo.require('dojo.i18n');
dojo.requireLocalization('moviedb', 'common');

dojo.declare('moviedb.ui.ActorItem', moviedb.ui.PersonItem, {
  templatePath: dojo.moduleUrl('moviedb', 'ui/_ActorItem/ActorItem.html'),
  widgetsInTemplate: true,

  postMixInProperties: function() {
    this._nls = dojo.i18n.getLocalization('moviedb', 'common');
    this.inherited(arguments);
  }
});
