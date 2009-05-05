dojo.provide('moviedb.ui._PersonEditor.View');
dojo.require('dojo.i18n');
dojo.require('dijit.form.DateTextBox');
dojo.require('dijit.form.Textarea');
dojo.require('dijit.form.ValidationTextBox');
dojo.require('dojox.form.BusyButton');
dojo.require('aiki.Form');
dojo.requireLocalization("dijit", "loading");

dojo.declare('moviedb.ui._PersonEditor.View', null, {
  baseClass: 'moviedbPersonEditor',
  iconClass: 'smallIcon personIcon',
  templatePath: dojo.moduleUrl('moviedb', 'ui/_PersonEditor/PersonEditor.html'),
  widgetsInTemplate: true,

  postMixInProperties: function(){
    this.inherited(arguments);
	if(!this.loadingLabel){
      this.loadingLabel = dojo.i18n.getLocalization("dijit", "loading", this.lang).loadingState;
	}
  }
});
