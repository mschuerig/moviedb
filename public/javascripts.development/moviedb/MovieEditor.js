dojo.provide('moviedb.MovieEditor');
dojo.require('dojo.i18n');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('dijit.form.DateTextBox');
dojo.require('dijit.form.Textarea');
dojo.require('dijit.form.ValidationTextBox');
dojo.require('dojox.form.BusyButton');
dojo.require('aiki.Form');
dojo.requireLocalization("dijit", "loading");

dojo.declare('moviedb.MovieEditor', [dijit._Widget, dijit._Templated], {
  store: null,
  object: null,

  baseClass: 'moviedbMovieEditor',
  iconClass: 'smallIcon movieIcon',
  templatePath: dojo.moduleUrl('moviedb', 'templates/MovieEditor.html'),
  widgetsInTemplate: true,

  getFeatures: function() {
    return {
      "aiki.Form.api.View": true,
      "aiki.api.Edit": true
	};
  },
  postMixInProperties: function(){
    this.inherited(arguments);
	if(!this.loadingLabel){
      this.loadingLabel = dojo.i18n.getLocalization("dijit", "loading", this.lang).loadingState;
	}
  },
  postCreate: function() {
    this.formNode.populate(this.store, this.object);
    dojo.connect(this.formNode, 'onChange', this, 'onChange');
  },
  getTitle: function() {
    return this.titleNode ? this.titleNode.attr('value') : this.loadingLabel;
  },
  isModified: function() {
    return this.formNode.isModified();
  },
  onChange: function() {
    console.log('*** MOVIE ON CHANGE'); //### REMOVE
  }
});
