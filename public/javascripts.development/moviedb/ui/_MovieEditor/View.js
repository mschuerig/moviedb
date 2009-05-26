dojo.provide('moviedb.ui._MovieEditor.View');
dojo.require('dojo.i18n');
dojo.require('dijit.form.DateTextBox');
dojo.require('dijit.form.Textarea');
dojo.require('dijit.form.ValidationTextBox');
dojo.require('dojox.form.BusyButton');
dojo.require('aiki.Form');
dojo.require('moviedb.ui.ActorItem');
dojo.require('moviedb.ui.DirectorItem');
dojo.requireLocalization("dijit", "loading");

dojo.declare('moviedb.ui._MovieEditor.View', null, {
  baseClass: 'moviedbMovieEditor',
  iconClass: 'smallIcon movieIcon',
  templatePath: dojo.moduleUrl('moviedb', 'ui/_MovieEditor/MovieEditor.html'),
  widgetsInTemplate: true,

  postMixInProperties: function(){
    this.inherited(arguments);
	  if(!this.loadingLabel){
      this.loadingLabel = dojo.i18n.getLocalization("dijit", "loading", this.lang).loadingState;
	  }
  }
});
